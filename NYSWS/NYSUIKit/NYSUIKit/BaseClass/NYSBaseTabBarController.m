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

#define isUserGradualAnimation  NO // 渐变动画
#define isUserZoomAnimation     YES // 缩放动画

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

- (void)addChildViewController:(UIViewController *)childController {
    [super addChildViewController:childController];
    
    UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
    appearance.backgroundColor = [UIColor whiteColor]; // 背景色
    appearance.shadowImage = [self imageWithColor:UIColor.clearColor size:CGSizeMake(1, 1)];
    childController.tabBarItem.standardAppearance = appearance;
    if (@available(iOS 15.0, *)) {
        childController.tabBarItem.scrollEdgeAppearance = appearance;
    }
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (isUserGradualAnimation) {
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.75f];
        [animation setType:@"rippleEffect"];
        [animation setSubtype:kCATransitionFromRight];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [tabBarController.view.layer addAnimation:animation forKey:@"switchView"];
    }
    
    return YES;
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (isUserZoomAnimation) {
        [self animationWithIndex:index];
    }
}

- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .5f;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 2.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.5)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.5)]];
    
    animation.values = values;
    [[tabbarbuttonArray[index] layer] addAnimation:animation forKey:nil];
    
    UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    if (@available(iOS 13.0, *)) {
        [feedBackGenertor impactOccurredWithIntensity:0.75];
    } else {
        [feedBackGenertor impactOccurred];
    }
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
