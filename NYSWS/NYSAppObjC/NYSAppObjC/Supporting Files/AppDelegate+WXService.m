//
//  AppDelegate+WXService.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/8/10.
//

#import "AppDelegate+WXService.h"

@implementation AppDelegate (WXService)

/// 初始化
/// - Parameters:
///   - launchOptions: 选项
///   - application: 应用
- (void)initWXApi:(NSDictionary *)launchOptions application:(UIApplication *)application {
    // 微信SDK初始化
#ifdef DEBUG
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
        NLog(@"WXApi log: %@", log);
    }];
#endif
    [WXApi registerApp:WXAPPID universalLink:@"https://xydgw.568lao.com/app/"];
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

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
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
    } else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]) {
        
    } else if (resp.errCode != WXSuccess) {
        [NYSTools showToast:resp.errStr];
    }
}

@end
