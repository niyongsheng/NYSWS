//
//  AppManager.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/10.
//

#import "AppManager.h"
#import <JPush/JPUSHService.h>

/// 是否需要调用接口登出登录
#define IsNeedLogout NO
/// 是否异步缓存
#define IS_ASYN_CACHE 1

@interface AppManager ()
/// 用户缓存对象
@property (nonatomic, strong) YYCache *userCache;
@end

@implementation AppManager

+ (AppManager *)sharedAppManager {
    static AppManager *appManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appManager = [[AppManager alloc] init];
        appManager.netStatus = -1;
        
        [NNotificationCenter addObserverForName:@"CacheAudioDataNotification" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            NSDictionary *obj = note.object;
            if ([obj[@"isShow"] intValue] == 1) {
                MBProgressHUD *processHud = [MBProgressHUD showHUDAddedTo:NAppWindow animated:YES];
                processHud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
                processHud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
                processHud.backgroundView.color = [[UIColor blackColor] colorWithAlphaComponent:0.65f];
                processHud.mode = MBProgressHUDModeIndeterminate; // MBProgressHUDModeDeterminateHorizontalBar;
                processHud.label.text = NLocalizedStr(@"CacheDownloading");
                
            } else if ([obj[@"isShow"] intValue] == 0) {
                MBProgressHUD *hud = [MBProgressHUD HUDForView:NAppWindow];
                [hud hideAnimated:YES];
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hud = [MBProgressHUD HUDForView:NAppWindow];
                    hud.progress = [obj[@"progress"] floatValue];
                });
            }
        }];
    });
    return appManager;
}

#pragma mark -- 登录 —-
- (void)loginHandler:(NUserLoginType)loginType authInfo:(NYSAuthInfo *)authInfo completion:(NYSLoginBlock)completion {
    // 0.缓存鉴权信息
    [NUserDefaults setValue:authInfo.token forKey:NUserTokenKey];
    [NUserDefaults synchronize];
    self.token = nil; // 主动置空读取缓存
    [[NYSKitManager sharedNYSKitManager] setToken:self.token];
    
    
    // 1.获取用户信息
    [self loadUserInfo:authInfo.token completion:^(BOOL success, NYSUserInfo *userInfo, NSError *error) {
        if (success) {
            completion(YES, @"登录成功");
            
        } else {
            completion(NO, @"加载用户信息出错");
            NLog(@"%@", error);
        }
    }];
}

#pragma mark -- 自动登录 —-
- (void)autoLoginToServer:(NYSLoginBlock)completion {
    
}

#pragma mark —- 加载用户信息 --
- (void)loadUserInfoCompletion:(NYSLoadUserInfoCompletion)completion {
    [self loadUserInfo:self.token completion:completion];
}

- (void)loadUserInfo:(NSString *)token completion:(NYSLoadUserInfoCompletion)completion {
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@"/index/Member/info"
                                       argument:nil
                                         remark:@"用户信息"
                                        success:^(id response) {
        @strongify(self)
        NSDictionary *data = nil;
        if ([response isKindOfClass:NSDictionary.class]) {
            data = response;
        } else {
            NSError *error = [NSError errorCode:-1 userInfo:@{@"resion" : @"数据格式错误"}];
            completion ? completion(NO, nil, error) : nil;
        }
        
        // 推送别名\标签
        NSString *alias = data[@"alias"];
        if ([alias isNotBlank]) {
            [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NLog(@"添加推送别名: code:%ld content:%@ seq:%ld", (long)iResCode, iAlias, (long)seq);
            } seq:++self.seq];
        }
        
        NSMutableSet *tagSet = [[NSMutableSet alloc] initWithArray:data[@"tags"]];
        if (tagSet.count > 0) {
            [tagSet addObject:data[@"account"]];
            [JPUSHService setTags:tagSet completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                NLog(@"添加推送标签: code:%ld content:%@ seq:%ld", (long)iResCode, iTags, (long)seq);
            } seq:++self.seq];
        }
        
        // 更新缓存
        [self.userCache setObject:data forKey:NUserInfoModelCache withBlock:^{
            @strongify(self)
            self.userInfo = nil; // 置空
            // 通知刷新UI
            [[NSNotificationCenter defaultCenter] postNotificationName:NNotificationReloadUserDetailInfo object:nil];
            NYSUserInfo *userInfo = [NYSUserInfo modelWithDictionary:data];
            completion ? completion(YES, userInfo, nil) : nil;
        }];
        
    } failed:^(NSError * _Nullable error) {
        
        completion ? completion(NO, nil, error) : nil;
    }];
}

#pragma mark —- 退出登录 --
- (void)logout:(NYSLogoutBlock)completion {
    
    // 1.退出登录接口
    if (IsNeedLogout) {
        [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                                url:@"/logout"
                                           argument:nil
                                             remark:@"登出"
                                            success:^(NSDictionary * _Nullable response) {
            
        } failed:^(NSError * _Nullable error) {
            
        }];
    }
    
    // 2.清空极光别名tag
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NLog(@"delAlias code:%ld content:%@ seq:%ld", (long)iResCode, iAlias, (long)seq);
    } seq:--_seq];
    [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NLog(@"clearTags code:%ld content:%@ seq:%ld", (long)iResCode, iTags, (long)seq);
    } seq:--_seq];
    
    // 3.清除APP角标
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    // 4.清空数据缓存
    [NUserDefaults removeObjectForKey:NUserTokenKey];
    
    // 5.清空当前用户信息
    self.seq = 0;
    self.token = nil;
    self.userInfo = nil;
    self.isLogined = NO;
    [[NYSKitManager sharedNYSKitManager] setToken:nil];
    
    // 6.删除文件缓存
    NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSFileManager * manager = [NSFileManager defaultManager];
    // 判断是否存在缓存文件
    if ([manager fileExistsAtPath:path]) {
        NSArray * childFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childFile) {
            NSString * absolutPat = [path stringByAppendingPathComponent:fileName];
            [manager removeItemAtPath:absolutPat error:nil];
        }
    }
    
    // 7.清除yywebimage缓存
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    [cache.memoryCache removeAllObjects];
    [cache.diskCache removeAllObjects];
    
    // 通知刷新UI
    [[NSNotificationCenter defaultCenter] postNotificationName:NNotificationReloadUserDetailInfo object:nil];
    
    [self.userCache removeAllObjectsWithBlock:^{
        if (completion) {
            completion(YES, nil);
        }
    }];
}

#pragma mark —- 被踢下线 —-
- (void)onKick {
    [self logout:^(BOOL success, id obj) {
        if (success) {
            [NYSTools showIconToast:@"已被强制下线" isSuccess:YES offset:UIOffsetMake(0, 0)];
        }
    }];
}

#pragma mark -- Lazy Load --
- (YYCache *)userCache {
    if (!_userCache) {
        _userCache = [[YYCache alloc] initWithName:NUserInfoModelCache];
    }
    return _userCache;
}

- (NSString *)token {
    if (!_token) {
        _token = [NUserDefaults valueForKey:NUserTokenKey];
    }
    return _token;
}

- (BOOL)isLogined {
    return [self.token isNotBlank] ? YES : NO;
}

- (NYSUserInfo *)userInfo {
    if (!_userInfo) {
        NSDictionary *userDict = (NSDictionary *)[self.userCache objectForKey:NUserInfoModelCache];
        _userInfo = [NYSUserInfo modelWithDictionary:userDict];
    }
    return _userInfo;
}

#pragma mark - 缓存已购课程数据
- (void)cacheAudioData:(BOOL)isShowProcess isRecache:(BOOL)isRecache {
    if (self.netStatus == 0) return;
    
    NSDictionary *argument = @{
        @"status": @1,
        @"is_page": @1
    };
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@"/index/Course/user_activation"
                                       argument:argument
                                         remark:@"缓存已购列表"
                                        success:^(id _Nullable response) {
        if ([response count] == 0) return;
        
        id cacheResponse = [NUserDefaults valueForKey:@"User_Purchased_List"];
        if ([cacheResponse count] == [response count] && !isRecache) return;
        
        if (isShowProcess) [NNotificationCenter postNotificationName:@"CacheAudioDataNotification" object:@{@"isShow":@1, @"progress":@0}];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray<NYSHomeCourseModel *> *array = [NSArray modelArrayWithClass:[NYSHomeCourseModel class] json:response];
            float total = 0;
            float index = 0;
            for (NYSHomeCourseModel *courseModel in array) {
                for (NYSChapter *chapterModel in courseModel.chapter) {
                    total += chapterModel.content.word_list.count;
                    total += chapterModel.content.statement_list.count;
                }
            }
#if IS_ASYN_CACHE
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
#endif
            for (NYSHomeCourseModel *courseModel in array) {
                for (NYSChapter *chapterModel in courseModel.chapter) {
                    for (NYSCatalogModel *catalogModel in chapterModel.content.word_list) {
                        NSString *path = catalogModel.url;
                        if ([path isNotBlank]) {
                            path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#^{}\"[]|\\<> "].invertedSet];
                            
                            NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                            NSString *filePath = [NSString stringWithFormat:@"%@/%@.caf", dirPath, [NSString stringWithUUID]];
                            catalogModel.url_path = filePath;
                            
#if IS_ASYN_CACHE
                            dispatch_async(queue, ^{
                                NSData *mp3Data = [NSData dataWithContentsOfURL:NCDNURL(path)];
                                [mp3Data writeToFile:filePath atomically:YES];
                            });
#else
                            NSData *mp3Data = [NSData dataWithContentsOfURL:NCDNURL(path)];
                            [mp3Data writeToFile:filePath atomically:YES];
#endif
                        }
                        
                        NSString *contentPath = catalogModel.content_url;
                        if ([contentPath isNotBlank]) {
                            contentPath = [contentPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#^{}\"[]|\\<> "].invertedSet];
                            
                            NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                            NSString *filePath = [NSString stringWithFormat:@"%@/%@.caf", dirPath, [NSString stringWithUUID]];
                            catalogModel.content_url_path = filePath;
                            
#if IS_ASYN_CACHE
                            dispatch_async(queue, ^{
                                NSData *mp3Data = [NSData dataWithContentsOfURL:NCDNURL(contentPath)];
                                [mp3Data writeToFile:filePath atomically:YES];
                            });
#else
                            NSData *mp3Data = [NSData dataWithContentsOfURL:NCDNURL(contentPath)];
                            [mp3Data writeToFile:filePath atomically:YES];
#endif
                        }
                        
                        index++;
                        [NNotificationCenter postNotificationName:@"CacheAudioDataNotification" object:@{@"isShow":@2, @"progress":@(index/total)}];
                    }
                    for (NYSCatalogModel *catalogModel in chapterModel.content.statement_list) {
                        NSString *path = catalogModel.url;
                        if ([path isNotBlank]) {
                            path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#^{}\"[]|\\<> "].invertedSet];
                            
                            NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                            NSString *filePath = [NSString stringWithFormat:@"%@/%@.caf", dirPath, [NSString stringWithUUID]];
                            catalogModel.url_path = filePath;
                            
#if IS_ASYN_CACHE
                            dispatch_async(queue, ^{
                                NSData *mp3Data = [NSData dataWithContentsOfURL:NCDNURL(path)];
                                [mp3Data writeToFile:filePath atomically:YES];
                            });
#else
                            NSData *mp3Data = [NSData dataWithContentsOfURL:NCDNURL(path)];
                            [mp3Data writeToFile:filePath atomically:YES];
#endif
                        }
                        
                        NSString *contentPath = catalogModel.content_url;
                        if ([contentPath isNotBlank]) {
                            contentPath = [contentPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#^{}\"[]|\\<> "].invertedSet];
                            
                            NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                            NSString *filePath = [NSString stringWithFormat:@"%@/%@.caf", dirPath, [NSString stringWithUUID]];
                            catalogModel.content_url_path = filePath;
                            
#if IS_ASYN_CACHE
                            dispatch_async(queue, ^{
                                NSData *mp3Data = [NSData dataWithContentsOfURL:NCDNURL(contentPath)];
                                [mp3Data writeToFile:filePath atomically:YES];
                            });
#else
                            NSData *mp3Data = [NSData dataWithContentsOfURL:NCDNURL(contentPath)];
                            [mp3Data writeToFile:filePath atomically:YES];
#endif
                        }
                        
                        index++;
                        [NNotificationCenter postNotificationName:@"CacheAudioDataNotification" object:@{@"isShow":@2, @"progress":@(index/total)}];
                    }
                }
            }
            
            [NUserDefaults setValue:[array modelToJSONObject] forKey:@"User_Purchased_List"];
            [NUserDefaults synchronize];
            
            [NNotificationCenter postNotificationName:@"CacheAudioDataNotification" object:@{@"isShow":@0, @"progress":@1}];
        });
    } failed:^(NSError * _Nullable error) {
        
    }];
}

@end
