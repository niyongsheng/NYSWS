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
    
    // 友盟初始化
    [self initUMeng];
    
    // 初始化window
    [self initWindow];
    
    // 初始化导航栏样式
    [self initNavBar];
    
    // 初始化app服务
    [self initService];
    
    // 网络监听
    [self initNetwork];
    
    // 推送初始化
    [self initPush:launchOptions application:application];
    
    
    [[ThemeManager sharedThemeManager] configTheme];
    
    id lang = [NSLocale preferredLanguages].firstObject;
    NSString *currLanguage = [NSBundle currentLanguage];
    NSLog(@"%@当前语言是=%@", lang, currLanguage);
    
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

//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    return window.sj_4_supportedInterfaceOrientations;
//}

@end
