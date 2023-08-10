//
//  AppDelegate.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/4/23.
//

#import "AppDelegate.h"
#import "AppDelegate+AppService.h"
#import "AppDelegate+PushService.h"
#import "AppDelegate+WXService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 初始化友盟统计
    [self initUMeng];
    
    // 初始化网络
    [self initNetwork];
    
    // 初始化window
    [self initWindow];
      
    // 初始化app服务
    [self initService];
    
    // 初始化导航栏样式
    [self initNavBar];
    
    // 初始化 IQKM
    [self initIQKeyboardManager];
    
    // 初始化主题
    [[ThemeManager sharedThemeManager] configTheme];
    
    // 初始化极光推送
    [self initPush:launchOptions application:application];

    // 初始化微信SDK
    [self initWXApi:launchOptions application:application];
    
    return YES;
}

@end
