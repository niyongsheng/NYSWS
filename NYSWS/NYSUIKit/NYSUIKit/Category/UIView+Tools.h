//
//  UIView+Tools.h
//
//  NYSUIKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tools)

/**
 StoryBoard tool
 */
/// 边线颜色
@property (nonatomic, strong) UIColor *borderColor;
/// 边线宽度
@property (nonatomic, assign) CGFloat borderWidth;
/// 圆角半径
@property (nonatomic, assign) CGFloat cornerRadius;

+ (UIView*)loadingAnimation;

+ (void)removeLoadingAnimation;


@end
