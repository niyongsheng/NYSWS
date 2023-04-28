//
//  NYSUIKitUtilities.h
//  NYSUIKit
//
//  Created by niyongsheng on 2023/4/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSUIKitUtilities : NSObject
/// 顶部状态栏高度（包括安全区）
+ (CGFloat)nys_statusBarHeight;
/// 导航栏的高度
+ (CGFloat)nys_navigationHeight;
/// 状态栏+导航栏的高度
+ (CGFloat)nys_navigationFullHeight;
/// 底部安全高度
+ (CGFloat)nys_safeDistanceBottom;

/// 读取包中图片资源
/// - Parameter name: 名称
+ (nullable UIImage *)imageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
