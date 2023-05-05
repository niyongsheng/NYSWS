//
//  NYSTabbarViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/4/28.
//

#import "NYSTabbarViewController.h"
#import "NYSHomeViewController.h"

@interface NYSTabbarViewController ()

@end

@implementation NYSTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NYSHomeViewController *homeVC = [NYSHomeViewController new];
    homeVC.tabBarItem.title = @"首页";
    homeVC.tabBarItem.image = [UIImage imageNamed:@"home_normal_icon"];
    homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"home_selected_icon"];
    [self addChildViewController:[[NYSBaseNavigationController alloc] initWithRootViewController:homeVC]];
    
    NYSBaseViewController *courseVC = [NYSBaseViewController new];
    courseVC.view.backgroundColor = UIColor.greenColor;
    courseVC.tabBarItem.title = @"课程";
    courseVC.tabBarItem.image = [UIImage imageNamed:@"course_normal_icon"];
    courseVC.tabBarItem.selectedImage = [UIImage imageNamed:@"course_selected_icon"];
    [self addChildViewController:[[NYSBaseNavigationController alloc] initWithRootViewController:courseVC]];
    
    NYSBaseViewController *mineVC = [NYSBaseViewController new];
    mineVC.tabBarItem.title = @"我的";
    mineVC.tabBarItem.image = [UIImage imageNamed:@"mine_normal_icon"];
    mineVC.tabBarItem.selectedImage = [UIImage imageNamed:@"mine_selected_icon"];
    [self addChildViewController:[[NYSBaseNavigationController alloc] initWithRootViewController:mineVC]];
    
}

@end
