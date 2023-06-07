//
//  AppDelegate+AppService.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^checkServiceCompletion)(BOOL isNormal);

@interface AppDelegate (AppService)

/** 初始化服务 */
- (void)initService;

/** 初始化 window */
- (void)initWindow;

/** 初始化导航栏 */
- (void)initNavBar;

/** 初始化 IQKM */
- (void)initIQKeyboardManager;

/** 初始化友盟 */
- (void)initUMeng;

/** 监听网络状态 */
- (void)initNetwork;

@end

NS_ASSUME_NONNULL_END
