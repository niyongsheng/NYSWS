//
//  NYSTabbarViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/4/28.
//

#import "NYSTabbarViewController.h"
#import "NYSHomeViewController.h"
#import "NYSCourseListVC.h"
#import "NYSMineViewController.h"

#define TintColor    [UIColor colorWithHexString:@"#EB5E20"]
#define NormalColor  [UIColor colorWithHexString:@"#8E8E8E"]

@interface NYSTabbarViewController ()

@end

@implementation NYSTabbarViewController

+ (void)initialize {
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: TintColor} forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 13.0, *)) {
        self.tabBar.unselectedItemTintColor = NormalColor;
        self.tabBar.tintColor = TintColor;
        
    } else {
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : NormalColor} forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : TintColor} forState:UIControlStateSelected];
    }
    
    NYSHomeViewController *homeVC = [NYSHomeViewController new];
    homeVC.tabBarItem.title = NSLocalizedStringFromTable(@"Home", @"InfoPlist", nil);
    homeVC.tabBarItem.image = [UIImage imageNamed:@"home_normal_icon"];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_selected_icon"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [self addChildViewController:[[NYSBaseNavigationController alloc] initWithRootViewController:homeVC]];
    
    NYSCourseListVC *courseVC = [NYSCourseListVC new];
    courseVC.tabBarItem.title = NSLocalizedStringFromTable(@"Course", @"InfoPlist", nil);
    courseVC.tabBarItem.image = [UIImage imageNamed:@"course_normal_icon"];
    courseVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"course_selected_icon"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [self addChildViewController:[[NYSBaseNavigationController alloc] initWithRootViewController:courseVC]];
    
    NYSMineViewController *mineVC = [NYSMineViewController new];
    mineVC.tabBarItem.title = NSLocalizedStringFromTable(@"Mine", @"InfoPlist", nil);
    mineVC.tabBarItem.image = [UIImage imageNamed:@"mine_normal_icon"];
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"mine_selected_icon"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [self addChildViewController:[[NYSBaseNavigationController alloc] initWithRootViewController:mineVC]];
}

@end
