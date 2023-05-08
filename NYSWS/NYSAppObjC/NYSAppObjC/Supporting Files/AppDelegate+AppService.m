//
//  AppDelegate+AppService.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "AppDelegate+AppService.h"
#import <WRNavigationBar/WRNavigationBar.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

#import <UMAPM/UMPage.h>
#import <UMAPM/UMLaunch.h>
#import <UMAPM/UMAPMConfig.h>
#import <UMAPM/UMCrashConfigure.h>

#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogManager.h>


@implementation AppDelegate (AppService)

#pragma mark —- 初始化服务 --
- (void)initService {
    // 注册登录状态监听
    [NNotificationCenter addObserver:self
                            selector:@selector(loginStateChange:)
                                name:NNotificationLoginStateChange
                              object:nil];
    
    // 网络状态监听
    [NNotificationCenter addObserver:self
                            selector:@selector(netWorkStateChange:)
                                name:NNotificationNetWorkStateChange
                              object:nil];
}


#pragma mark —- 初始化window --
- (void)initWindow {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [[NYSTabbarViewController alloc] init];
    [self.window makeKeyAndVisible];
}

#pragma mark -- 初始化三方导航栏样式 --
- (void)initNavBar {
    [WRNavigationBar wr_widely];
    [WRNavigationBar wr_setBlacklist:@[@"SpecialController",
                                       @"TZPhotoPickerController",
                                       @"TZGifPhotoPreviewController",
                                       @"TZAlbumPickerController",
                                       @"TZPhotoPreviewController",
                                       @"TZVideoPlayerController"]];
    
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:UIColor.whiteColor];
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor blackColor]];
    // 设置导航栏标题默认颜色
    [WRNavigationBar wr_setDefaultNavBarTitleColor:[UIColor blackColor]];
    // 统一设置状态栏样式
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleDefault];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
}

#pragma mark -- 初始化 IQKM --
- (void)initIQKeyboardManager {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

#pragma mark -- 友盟 初始化 --
- (void)initUMeng {
//    [NSURLProtocol registerClass:[UMURLProtocol class]];
    UMAPMConfig *config = [UMAPMConfig defaultConfig];
    config.networkEnable = YES;
    [UMCrashConfigure setAPMConfig:config];
    
    // 友盟统计+分享
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:UMengKey channel:@"App Store"];
    [UMConfigure setAnalyticsEnabled:YES];
}

#pragma mark -- 登录状态变化 --
- (void)loginStateChange:(NSNotification *)notification {
    BOOL loginSuccess = [notification.object boolValue];
    if (loginSuccess) { // 登陆成功加载主窗口控制器
        
        CATransition *anima = [CATransition animation];
        anima.type = @"cube";
        anima.subtype = kCATransitionFromRight;
        anima.duration = 0.3f;
        
        [NAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
        
    } else { // 登陆失败加载登陆页面控制器
        
        CATransition *anima = [CATransition animation];
        anima.type = @"cube";
        anima.subtype = kCATransitionFromLeft;
        anima.duration = 0.3f;

//        NRootViewController = [[NYSBaseNavigationController alloc] initWithRootViewController:[NYSLoginVC new]];
        [NAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
    }
}

#pragma mark -- 网络状态变化 --
- (void)netWorkStateChange:(NSNotification *)notification {
    BOOL isNetWork = [notification.object boolValue];
    
    if (isNetWork) { // 有网络
       
    }
}

#pragma mark -- 网络状态 --
- (void)initNetwork {
    
    [[NYSKitManager sharedNYSKitManager] setHost:APP_BASE_URL];
    [[NYSKitManager sharedNYSKitManager] setToken:@""];
    
    // 网络状态改变监听
    
}

// iOS9以上使用以下方法
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([UMAPMConfig handleUrl:url] ) {
        return YES;
    }
    //其它第三方处理
    return YES;
}

@end
