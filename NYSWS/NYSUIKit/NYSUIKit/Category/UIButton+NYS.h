//
//  UIButton+NYS.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define defaultInterval 1  // 默认时间间隔

@interface UIButton (NYS)
/// 点击响应范围
/// @param edge 范围
- (void)enlargeTouchEdge:(UIEdgeInsets)edge;

/// 设置点击时间间隔
@property (nonatomic, assign) NSTimeInterval timeInterval;
/// 用于设置单个按钮不需要被hook
@property (nonatomic, assign) BOOL isIgnore;
@end

NS_ASSUME_NONNULL_END
