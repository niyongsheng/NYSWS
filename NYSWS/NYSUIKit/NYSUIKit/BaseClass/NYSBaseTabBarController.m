//
//  NYSBaseTabBarController.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/14.
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSBaseTabBarController.h"
#import "NYSBaseNavigationController.h"
#import "LEETheme.h"

@interface NYSBaseTabBarController () <UITabBarControllerDelegate>

@end

@implementation NYSBaseTabBarController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self configTheme];
    self.delegate = self;
}

- (void)configTheme {
    
    if ([[UIDevice currentDevice] systemVersion].floatValue < 13.0) {
        // push\pop导航栏右上角阴影
        self.view.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
        
        self.tabBar.lee_theme
        .LeeConfigBarTintColor(@"common_bg_color_2")
        .LeeConfigTintColor(@"app_theme_color");
    } else {
        self.tabBar.lee_theme
        .LeeConfigTintColor(@"app_theme_color");
    }
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

#pragma mark - auto rotate
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

@end
