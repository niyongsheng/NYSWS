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

#define NormalColor  [UIColor colorWithHexString:@"#8E8E8E"]

@interface NYSTabbarViewController ()

@end

@implementation NYSTabbarViewController

- (instancetype)initWithIsRecache:(BOOL)isRecache {
    self = [super init];
    if (self) {
        _isRecache = isRecache;
//        [NAppManager cacheAudioData:YES isRecache:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 点击动画
    self.tabBarInteractionEffectStyle = NYSBaseTabBar_InteractionEffectStyleSpring;
    self.isResetTabBarItemStyle = YES;
    self.isOpenGradualAnimation = YES;
    
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
