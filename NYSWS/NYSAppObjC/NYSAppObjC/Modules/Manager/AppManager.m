//
//  AppManager.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/10.
//

#import "AppManager.h"
#import <JPush/JPUSHService.h>

/// 是否需要主动登出
#define IsNeedLogout 0

@interface AppManager ()
/// 用户缓存对象
@property (nonatomic, strong) YYCache *userCache;
@end

@implementation AppManager

+ (AppManager *)sharedAppManager {
    static AppManager *appManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appManager = [[self alloc] init];
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NNotificationChangeDefaultBuilding object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            [appManager loadUserInfoCompletion:nil];
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

    // 4.移除缓存
    [NUserDefaults removeObjectForKey:NUserTokenKey];
    [self.userCache removeAllObjectsWithBlock:^{
        if (completion) {
            completion(YES, nil);
        }
    }];
    
    // 5.清空当前用户信息
    self.seq = 0;
    self.token = nil;
    self.userInfo = nil;
    self.isLogined = NO;
    [[NYSKitManager sharedNYSKitManager] setToken:nil];
    
    // 通知刷新UI
    [[NSNotificationCenter defaultCenter] postNotificationName:NNotificationReloadUserDetailInfo object:nil];
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

@end
