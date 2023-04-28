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
@property (nonatomic, strong) NSString * _Nonnull token;

@end

NS_ASSUME_NONNULL_END
