//
//  NYSKitManager.h
//  NYSKit
//
//  Created by niyongsheng on 2023/4/23.
//

#import <Foundation/Foundation.h>

@interface NYSKitManager : NSObject

+ (NYSKitManager *_Nonnull)sharedNYSKitManager;

/// 请求地址
@property (nonatomic, strong) NSString * _Nonnull host;
/// 授权令牌
@property (nonatomic, strong) NSString * token;
/// 令牌失效错误码
@property (nonatomic, strong) NSString * _Nonnull tokenInvalidCode;
@property (nonatomic, strong) NSString * _Nonnull tokenInvalidMessage;
/// 被踢/其他设备登录-错误码
@property (nonatomic, strong) NSString * _Nonnull kickedCode;
@end
