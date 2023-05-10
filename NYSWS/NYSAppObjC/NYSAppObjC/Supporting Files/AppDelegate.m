//
//  AppDelegate.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/4/23.
//

#import "AppDelegate.h"
#import "AppDelegate+AppService.h"
#import "AppDelegate+PushService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 初始化友盟
    [self initUMeng];
    
    // 初始化window
    [self initWindow];
      
    // 初始化app服务
    [self initService];
    
    // 初始化网络
    [self initNetwork];
    
    // 初始化导航栏样式
    [self initNavBar];
    
    // 初始化主题
    [[ThemeManager sharedThemeManager] configTheme];
    
    // 初始化极光推送
    [self initPush:launchOptions application:application];

    // 暂不适配暗黑模式
    if (@available(iOS 13.0, *))
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    
    return YES;
}

#pragma mark - App lifecycle
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark - 如需使用远程推送相关功能，请实现以下方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 收到远程推送消息
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
