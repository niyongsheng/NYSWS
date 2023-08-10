//
//  NYSRequestManager.m
//  ICMSClient
//
//  Created by niyongsheng.github.io on 2021/12/30.
//  Copyright © 2021 NYS. ALL rights reserved.
//

#import "NYSNetRequest.h"
#import "PublicHeader.h"
#import "NYSTools.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworking.h>

#define TimeoutInterval 15
#define ShowDelayLoading 4.5f

@interface NYSNetRequest ()

@end

@implementation NYSNetRequest

+ (AFHTTPSessionManager *)sharedManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
        [contentTypes addObject:@"text/html"];
        [contentTypes addObject:@"text/plain"];
        [contentTypes addObject:@"application/json"];
        [contentTypes addObject:@"image/jpeg"];
        [contentTypes addObject:@"image/jpg"];
        [contentTypes addObject:@"application/octet-stream"];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:TimeoutInterval];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NNotificationNetworkChange object:@(status)];
        }];
    });
    return manager;
}

+ (NSDictionary *)headers {
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [headerDic setValue:identifierStr forKey:@"identifier"];
    [headerDic setValue:[[NYSKitManager sharedNYSKitManager] token] forKey:@"token"];
    [headerDic setValue:[[UIDevice currentDevice] systemName] forKey:@"deviceSystemName"];
    [headerDic setValue:[[UIDevice currentDevice] systemVersion] forKey:@"systemVersion"];
    [headerDic setValue:[[UIDevice currentDevice] localizedModel] forKey:@"localizedModel"];
    [headerDic setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"appVersion"];
    
    return headerDic;
}

#pragma mark - 常用请求
+ (void)requestNetworkWithType:(NYSNetRequestType)type url:(NSString * _Nonnull)url argument:(id)argument remark:(NSString *)remark success:(NYSNetRequestSuccess _Nullable )success failed:(NYSNetRequestFailed _Nullable )failed {
    
    NSDictionary *header = [self headers];
    NSString *urlStr = [[[NYSKitManager sharedNYSKitManager] host] stringByAppendingString:url];
    if ([url containsString:@"http"]) {
        urlStr = url;
    }
    switch (type) {
            
        case GET: {
            [[self sharedManager] GET:urlStr parameters:argument headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                handelLog(remark, urlStr, @"GET", header, argument, responseObject, NO);
                handelResponse(argument, failed, remark, responseObject, success, urlStr);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failed) {
                    failed(error);
                    handelError(error);
                }
            }];
        }
            break;
            
        case POST: {
            [[self sharedManager] POST:urlStr parameters:argument headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                handelLog(remark, urlStr, @"POST", header, argument, responseObject, NO);
                handelResponse(argument, failed, remark, responseObject, success, urlStr);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failed) {
                    failed(error);
                    handelError(error);
                }
            }];
        }
            break;
            
        case PUT: {
            [[self sharedManager] PUT:urlStr parameters:argument headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                handelLog(remark, urlStr, @"PUT", header, argument, responseObject, NO);
                handelResponse(argument, failed, remark, responseObject, success, urlStr);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failed) {
                    failed(error);
                    handelError(error);
                }
            }];
        }
            break;
            
        case DELTTE: {
            [[self sharedManager] DELETE:urlStr parameters:argument headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                handelLog(remark, urlStr, @"DELTTE", header, argument, responseObject, NO);
                handelResponse(argument, failed, remark, responseObject, success, urlStr);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failed) {
                    failed(error);
                    handelError(error);
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 文件上传
+ (void)uploadImagesWithType:(NYSNetRequestType)type
                       url:(NSString * _Nonnull)url
                  argument:(id)argument
                      name:(NSString *)name
                    files:(NSArray *)files
                 fileNames:(NSArray<NSString *> *)fileNames
                imageScale:(CGFloat)imageScale
                 imageType:(NSString *)imageType
                    remark:(id)remark
                  progress:(nullable void (^)(NSProgress * _Nonnull))process
                   success:(NYSNetRequestSuccess _Nullable )success
                    failed:(NYSNetRequestFailed _Nullable )failed {
    
    NSDictionary *header = [self headers];
    NSString *urlStr = [[[NYSKitManager sharedNYSKitManager] host] stringByAppendingString:url];
    
    [[self sharedManager] POST:urlStr parameters:argument headers:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSUInteger i = 0; i < files.count; i++) {
            // 图片经过等比压缩后得到的二进制文件
            NSData *imageData = UIImageJPEGRepresentation(files[i], imageScale ? : 1.0f);
            // 生成文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd_HH:mm:ss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *imageFileName = [NSString stringWithFormat:@"%@_%ld.%@",str,i+1,imageType?:@"png"];
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:fileNames ? [NSString stringWithFormat:@"%@.%@",fileNames[i],imageType?:@"png"] : imageFileName
                                    mimeType:[NSString stringWithFormat:@"image/%@",imageType ?: @"png"]];
        
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"上传中..."];
            process ? process(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        handelLog(remark, urlStr, @"POST", header, argument, responseObject, NO);
        handelResponse(argument, failed, remark, responseObject, success, urlStr);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (failed) {
            failed(error);
            handelError(error);
        }
    }];
}

#pragma mark - 阿里云OSS图片上传
+ (void)ossUploadImageWithuUrlStr:(NSString *)urlStr
                         argument:(id)argument
                      name:(NSString *)name
                    image:(UIImage *)image
                 imageName:(NSString *)imageName
                imageScale:(CGFloat)imageScale
                 imageType:(NSString *)imageType
                    remark:(id)remark
                  progress:(nullable void (^)(NSProgress * _Nonnull))process
                   success:(NYSNetRequestSuccess _Nullable )success
                    failed:(NYSNetRequestFailed _Nullable )failed {
    
    [[self sharedManager] POST:urlStr parameters:argument headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy_MM_ddHH:mm:ss";
            NSString *tempName = [formatter stringFromDate:[NSDate date]];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.65f);
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:imageName ? [NSString stringWithFormat:@"%@.%@", imageName, imageType ?:@"png"] : [NSString stringWithFormat:@"%@.%@", tempName, imageType]
                                    mimeType:[NSString stringWithFormat:@"image/%@",imageType ?: @"png"]];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"上传中..."];
            process ? process(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        handelLog(remark, urlStr, @"POST", nil, argument, responseObject, NO);
        handelResponse(argument, failed, remark, responseObject, success, urlStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            failed(error);
            handelError(error);
        }
    }];
}

#pragma mark - JSON传参网络请求
+ (void)jsonNetworkRequestWithMethod:(NSString * _Nonnull)method url:(NSString * _Nonnull)url argument:(id)argument remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess)success failed:(NYSNetRequestFailed)failed {
    [self jsonRequestWithMethod:method url:url argument:argument isCheck:YES remark:remark success:success failed:failed];
}

+ (void)jsonNoCheckNetworkRequestWithMethod:(NSString * _Nonnull)method url:(NSString * _Nonnull)url argument:(id)argument remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess)success failed:(NYSNetRequestFailed)failed {
    [self jsonRequestWithMethod:method url:url argument:argument isCheck:NO remark:remark success:success failed:failed];
}

+ (void)jsonRequestWithMethod:(NSString * _Nonnull)method url:(NSString * _Nonnull)url argument:(id)argument isCheck:(BOOL)isCheck remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess)success failed:(NYSNetRequestFailed)failed {
    // 加载动画-延时执行
    [self performSelector:@selector(delayLoadingMethod) withObject:nil afterDelay:ShowDelayLoading];
    // 监听网络状态
    [self sharedManager];
    
    NSString *urlStr = [[[NYSKitManager sharedNYSKitManager] host] stringByAppendingString:url];
    if ([url containsString:@"http"]) {
        urlStr = url;
    }
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:urlStr parameters:argument error:nil];
    [request setAllHTTPHeaderFields:[self headers]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置cookie
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [request setValue:[NSString stringWithFormat:@"%@=%@", [defaults objectForKey:@"cookie.name"], [defaults objectForKey:@"cookie.value"]] forHTTPHeaderField:@"Cookie"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request
                                               uploadProgress:nil
                                             downloadProgress:nil
                                            completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [SVProgressHUD dismissWithDelay:1.0f];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayLoadingMethod) object:nil];
        
        handelLog(remark, urlStr, @"POST", [request allHTTPHeaderFields], argument, responseObject, YES);
        if (!error) {
            // 获取cookie
            NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie *cookie in [cookieJar cookies]) {
                if ([cookie.name isEqualToString:@"PHPSESSID"]) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:cookie.name forKey:@"cookie.name"];
                    [defaults setObject:cookie.value forKey:@"cookie.value"];
                    [defaults synchronize];
                }
            }
            
            if (isCheck) {
                handelResponse(argument, failed, remark, responseObject, success, urlStr);
            } else {
                if (success) {
                    success(responseObject);
                }
            }
            
        } else {
            DBGLog(@"\n[%@]\n%@", @"❌错误", error.localizedDescription);
            if (failed) {
                failed(error);
                handelError(error);
            }
        }
    }];
    
    [task resume];
}

+ (NSString *)jsonPrettyStringEncoded:(NSDictionary *)dict {
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

#pragma mark - 响应体处理
static void handelResponse(id argument, NYSNetRequestFailed  _Nullable failed, NSString *remark, id  _Nullable responseObject, NYSNetRequestSuccess  _Nullable success, NSString * _Nonnull url) {
    if ([responseObject isKindOfClass:NSData.class]) {
        success(responseObject);
        return;
    }
    NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
    NSString *msg = @"unknown error";
    for (NSString *key in [[[NYSKitManager sharedNYSKitManager] msgKey] componentsSeparatedByString:@","]) {
        NSString *message = [responseObject objectForKey:key];
        if (![NYSTools stringIsNull:message]) {
            msg = message;
            break;
        }
    }
    
    NSArray *normalCodeArray = [[[NYSKitManager sharedNYSKitManager] normalCode] componentsSeparatedByString:@","];
    BOOL isNormal = [normalCodeArray containsObject:[NSString stringWithFormat:@"%ld", code]];
    if (isNormal) { // 正常返回
        NSDictionary *data = [responseObject objectForKey:@"data"];
        if (success) {
            success(data);
        }
    } else if (code == [[[NYSKitManager sharedNYSKitManager] kickedCode] integerValue]) { // 强制下线
        [[NSNotificationCenter defaultCenter] postNotificationName:NNotificationOnKick object:msg];
        
    } else if (code == [[[NYSKitManager sharedNYSKitManager] tokenInvalidCode] integerValue]) { // token失效
        if ([msg containsString:[[NYSKitManager sharedNYSKitManager] tokenInvalidMessage]]) { // 防止后端token失效的code不唯一
            [[NSNotificationCenter defaultCenter] postNotificationName:NNotificationTokenInvalidation object:msg];
        }
        [NYSTools showBottomToast:msg];
    } else { // 其他错误
        if (failed) {
            NSError *error = [NSError errorWithDomain:@"NYSNetRequestErrorDomain" code:code userInfo:@{NSLocalizedDescriptionKey:msg}];
            failed(error);
        } else {
            [NYSTools showBottomToast:msg];
        }
        
        if ([[NYSKitManager sharedNYSKitManager] isAlwaysShowErrorMsg])
            [NYSTools showBottomToast:msg];
    }
}

#pragma mark - 错误码处理
static void handelError(NSError * _Nullable error) {
    
    if (error.code == -1001) {
        [NYSTools showToast:@"请求超时，请检查网络！"];
        
    } else if (error.code == -1004) {
        [NYSTools showToast:@"无法连接到服务器"];
        
    } else if (error.code == -1009) {
        [NYSTools showToast:@"网络不可用"];
        
    } else if (error.code == -1011) {
        [NYSTools showToast:@"服务暂时不可用"];
        
    } else {
        [NYSTools showToast:error.localizedDescription];
    }
#ifdef DEBUG
    NSLog(@"❌%@", error);
#endif
}

#pragma mark - 日志打印
static void handelLog(NSString *remark, NSString *urlStr, NSString *type, NSDictionary *header, NSDictionary *argument, id responseObject, BOOL isJsosn) {
    id resp = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        resp = [NYSNetRequest jsonPrettyStringEncoded:responseObject];
    } else {
        resp = responseObject;
    }
    
    DBGLog(@"[%@]%@->📩:\n%@\n[Header]请求头:\n%@\n[%@]传参:\n%@\n[Response]响应:\n%@", type, remark, urlStr, header, isJsosn ? @"Json" : @"Form", [NYSNetRequest jsonPrettyStringEncoded:argument], resp);
}

/// 数据加载中
+ (void)delayLoadingMethod {
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"Loading..."];
}

@end
