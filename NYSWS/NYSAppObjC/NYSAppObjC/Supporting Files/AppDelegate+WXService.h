//
//  AppDelegate+WXService.h
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/8/10.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (WXService)
<
WXApiDelegate
>
/// 初始化微信SDK
- (void)initWXApi:(NSDictionary *)launchOptions application:(UIApplication *)application;
@end

NS_ASSUME_NONNULL_END
