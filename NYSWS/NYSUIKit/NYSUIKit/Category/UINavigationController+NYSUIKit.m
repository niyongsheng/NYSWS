//
//  UINavigationController+NYSUIKit.m
//  NYSUIKit
//
//  Created by niyongsheng on 2023/5/8.
//

#import "UINavigationController+NYSUIKit.h"

@implementation UINavigationController (NYSUIKit)

/// pop到指定控制器
/// @param aClass 类
/// @param animated 动画
- (void)popToViewControllerClass:(Class)aClass animated:(BOOL)animated {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:aClass]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

@end
