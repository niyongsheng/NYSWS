//
//  NYSRequestManager.h
//  ICMSClient
//
//  Created by niyongsheng.github.io on 2021/12/30.
//  Copyright © 2021 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

// 被踢下线
#define NNotificationOnKick                     @"KNotificationOnKick"
// 令牌失效
#define NNotificationTokenInvalidation          @"KNotificationTokenInvalidation"
// 网络状态
#define NNotificationNetworkChange              @"KNotificationNetworkChange"

typedef enum : NSUInteger {
    GET,
    POST,
    DELTTE,
    PUT
} NYSNetRequestType;

typedef void(^NYSNetRequestSuccess)(NSDictionary * _Nullable response);
typedef void(^NYSNetRequestFailed)(NSError * _Nullable error);

@interface NYSNetRequest : NSObject

/// Form表单网络请求
+ (void)requestNetworkWithType:(NYSNetRequestType)type url:(NSString * _Nonnull)url argument:(id _Nullable)argument remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess _Nullable)success failed:(NYSNetRequestFailed _Nullable)failed;

/// JSON传参网络请求
+ (void)jsonNetworkRequestWithMethod:(NSString * _Nonnull)method url:(NSString * _Nonnull)url argument:(id _Nullable)argument remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess _Nullable)success failed:(NYSNetRequestFailed _Nullable)failed;

/// JSON传参网络请求(不统一检查接口返回数据的合法性)
+ (void)jsonNoCheckNetworkRequestWithMethod:(NSString * _Nonnull)method url:(NSString * _Nonnull)url argument:(id _Nullable)argument remark:(NSString * _Nullable)remark success:(NYSNetRequestSuccess _Nullable)success failed:(NYSNetRequestFailed _Nullable)failed;

/// 文件上传
+ (void)uploadImagesWithType:(NYSNetRequestType)type
                       url:(NSString * _Nonnull)url
                  argument:(id _Nullable)argument
                      name:(NSString * _Nonnull)name
                       files:(NSArray * _Nonnull)files
                 fileNames:(NSArray<NSString *> *_Nullable)fileNames
                imageScale:(CGFloat)imageScale
                 imageType:(NSString * _Nullable)imageType
                    remark:(id _Nullable)remark
                  progress:(nullable void (^)(NSProgress * _Nonnull))process
                   success:(NYSNetRequestSuccess _Nullable )success
                      failed:(NYSNetRequestFailed _Nullable )failed;

/// 阿里云OSS图片上传
+ (void)ossUploadImageWithuUrlStr:(NSString * _Nonnull)urlStr
                         argument:(id _Nullable)argument
                      name:(NSString * _Nonnull)name
                    image:(UIImage * _Nonnull)image
                 imageName:(NSString * _Nonnull)imageName
                imageScale:(CGFloat)imageScale
                 imageType:(NSString * _Nullable)imageType
                    remark:(id _Nullable)remark
                  progress:(nullable void (^)(NSProgress * _Nullable))process
                   success:(NYSNetRequestSuccess _Nullable )success
                          failed:(NYSNetRequestFailed _Nullable )failed;

@end
