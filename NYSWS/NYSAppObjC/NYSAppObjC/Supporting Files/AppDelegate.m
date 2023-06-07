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
<
WXApiDelegate
>

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
    
    // 初始化 IQKM
    [self initIQKeyboardManager];
    
    // 初始化主题
    [[ThemeManager sharedThemeManager] configTheme];
    
    // 初始化极光推送
    [self initPush:launchOptions application:application];

    // 暂不适配暗黑模式
    if (@available(iOS 13.0, *))
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    
    // 微信SDK初始化
    [WXApi registerApp:WXAPPID];
    
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

#pragma mark - wechat pay
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp*)resp;
        switch(response.errCode) {
            case WXSuccess:
                [[JDStatusBarNotificationPresenter sharedPresenter] presentWithText:@"Pay Success" dismissAfterDelay:1.5f includedStyle:JDStatusBarNotificationIncludedStyleSuccess];
                break;
                
            default:
                [[JDStatusBarNotificationPresenter sharedPresenter] presentWithText:[NSString stringWithFormat:@"Pay Fail, Retcode=%d", resp.errCode] dismissAfterDelay:1.5f includedStyle:JDStatusBarNotificationIncludedStyleSuccess];
                break;
        }
    }
}

@end
