//
//  NYSKitManager.h
//  NYSKit
//
//  Created by niyongsheng on 2023/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSKitManager : NSObject

+ (NYSKitManager *)sharedNYSKitManager;

/// 请求地址
@property (nonatomic, strong) NSString * _Nonnull host;
/// 授权令牌
@property (nonatomic, strong) NSString * token;
/// 令牌失效错误码
@property (nonatomic, strong) NSString * tokenInvalidCode;
/// 被踢/其他设备登录-错误码
@property (nonatomic, strong) NSString * kickedCode;
@end

NS_ASSUME_NONNULL_END
