//
//  NYSBaseTabBarController.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/14.
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NYSBaseTabBarInteractionEffectStyle) {
    NYSBaseTabBar_InteractionEffectStyleNone,     // 无 默认
    NYSBaseTabBar_InteractionEffectStyleSpring,   // 放大放小
    NYSBaseTabBar_InteractionEffectStyleShake,    // 摇动动画效果
    NYSBaseTabBar_InteractionEffectStyleAlpha     // 透明动画效果
};

@interface NYSBaseTabBarController : UITabBarController
/// 点击动画类型
@property (nonatomic, assign) NYSBaseTabBarInteractionEffectStyle tabBarInteractionEffectStyle;
/// 是否启用渐变切换
@property (nonatomic, assign) BOOL isUserGradualAnimation;
@end

NS_ASSUME_NONNULL_END
