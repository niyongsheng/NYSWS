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

#import "NYSMyCourseListVC.h"

#define isMustLogin     NO
#define isNeedLoginTips NO

@implementation AppDelegate (AppService)

#pragma mark —- 初始化服务 --
- (void)initService {
    // 注册登录状态监听
    [NNotificationCenter addObserver:self
                            selector:@selector(loginStateChange:)
                                name:NNotificationLoginStateChange
                              object:nil];
    
    // 鉴权失效监听
    [NNotificationCenter addObserver:self
                            selector:@selector(tokenInvalidation:)
                                name:NNotificationTokenInvalidation
                              object:nil];
    
    // 网络状态监听
    [NNotificationCenter addObserver:self
                            selector:@selector(netWorkStateChange:)
                                name:NNotificationNetworkChange
                              object:nil];
    
    // 检查更新
    if ([FirApiToken isNotBlank]) {
        [FIRVersionCheck setAPIToken:FirApiToken];
        [FIRVersionCheck setTargetController:NRootViewController];
        [FIRVersionCheck check];
    }
    
    id lang = [NSLocale preferredLanguages].firstObject;
    NSString *currLanguage = [NSBundle currentLanguage];
    NLog(@"%@当前语言是=%@", lang, currLanguage);
}


#pragma mark —- 初始化window --
- (void)initWindow {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    if ([NAppManager isLogined]) {
        self.window.rootViewController = [[NYSTabbarViewController alloc] init];
    } else {
        if (isMustLogin) {
            self.window.rootViewController = [[NYSBaseNavigationController alloc] initWithRootViewController:[NYSLoginVC new]];
        } else {
            self.window.rootViewController = [[NYSTabbarViewController alloc] init];
        }
    }
    [self.window makeKeyAndVisible];
    
    // 暂不适配暗黑模式
    if (@available(iOS 13.0, *))
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
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
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 50;
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
        
        NRootViewController = [[NYSTabbarViewController alloc] initWithIsRecache:YES];
        [NAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
        
    } else { // 登陆失败加载登陆页面控制器
        
        CATransition *anima = [CATransition animation];
        anima.type = @"cube";
        anima.subtype = kCATransitionFromLeft;
        anima.duration = 0.3f;
        
        NRootViewController = [[NYSBaseNavigationController alloc] initWithRootViewController:[NYSLoginVC new]];
        [NAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
    }
}

#pragma mark -- 鉴权失效监听 --
- (void)tokenInvalidation:(NSNotification *)notification {
    [NAppManager logout:^(BOOL success, id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isNeedLoginTips) {
                NYSAlertView *alertView = [[NYSAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.7, RealValue(205))];
                alertView.titleL.text = NLocalizedStr(@"Tips");
                alertView.subtitleL.text = @"您还没有登陆";
                alertView.iconIV.image = [UIImage imageNamed:@"img_alert_lingdang"];
                [alertView.commitBtn setTitle:@"去登录" forState:UIControlStateNormal];
                alertView.block = ^(id obj) {
                    if ([obj isEqual:@"1"]) {
                        NYSBaseNavigationController *loginVC = [[NYSBaseNavigationController alloc] initWithRootViewController:[NYSLoginVC new]];
                        [NRootViewController presentViewController:loginVC animated:YES completion:nil];
                    }
                    [FFPopup dismissAllPopups];
                };
                FFPopup *popup = [FFPopup popupWithContentView:alertView showType:FFPopupShowType_GrowIn dismissType:FFPopupDismissType_ShrinkOut maskType:FFPopupMaskType_Dimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
                popup.showInDuration = 0.5f;
                popup.maskType = FFPopupMaskType_Dimmed;
                FFPopupLayout layout = FFPopupLayoutMake(FFPopupHorizontalLayout_Center, FFPopupVerticalLayout_Center);
                [popup showWithLayout:layout];
                
            } else {
                NPostNotification(NNotificationLoginStateChange, @NO)
            }
        });
    }];
}

#pragma mark -- 网络状态变化 --
- (void)netWorkStateChange:(NSNotification *)notification {
    NSInteger netStatus = [notification.object integerValue];
    NAppManager.netStatus = netStatus;
    switch (netStatus) {
        case -1: {
            [[JDStatusBarNotificationPresenter sharedPresenter] presentWithText:NLocalizedStr(@"NetworkUnknown") dismissAfterDelay:1.1f includedStyle:JDStatusBarNotificationIncludedStyleError];
        }
            break;
            
        case 0: {
            [[JDStatusBarNotificationPresenter sharedPresenter] presentWithText:NLocalizedStr(@"NetworkNotReachable") dismissAfterDelay:1.5f includedStyle:JDStatusBarNotificationIncludedStyleDefaultStyle];
            
            if (NAppManager.isLogined) {
                NYSNetAlertView *alertView = [[NYSNetAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.75, RealValue(220))];
                alertView.block = ^(id obj) {
                    if ([obj isEqual:@"1"]) {
                        NYSMyCourseListVC *hVC = [[NYSMyCourseListVC alloc] init];
                        hVC.index = @"1";
                        hVC.isOffLine = YES;
                        hVC.navigationItem.title = NLocalizedStr(@"Purchased");
                        NYSBaseNavigationController *nav = [[NYSBaseNavigationController alloc] initWithRootViewController:hVC];
                        nav.modalPresentationStyle = UIModalPresentationFullScreen;
                        [NRootViewController presentViewController:nav animated:YES completion:nil];
                    } else {
                        [FFPopup dismissAllPopups];
                    }
                };
                FFPopup *popup = [FFPopup popupWithContentView:alertView showType:FFPopupShowType_BounceIn dismissType:FFPopupDismissType_ShrinkOut maskType:FFPopupMaskType_Dimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
                FFPopupLayout layout = FFPopupLayoutMake(FFPopupHorizontalLayout_Center, FFPopupVerticalLayout_Center);
                [popup showWithLayout:layout];
            }
        }
            break;
            
        case 1: {
            [[JDStatusBarNotificationPresenter sharedPresenter] presentWithText:NLocalizedStr(@"NetworkWWAN") dismissAfterDelay:1.1f includedStyle:JDStatusBarNotificationIncludedStyleDefaultStyle];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NNotificationReloadData" object:nil];
            }
            break;
        
        case 2: {
            [[JDStatusBarNotificationPresenter sharedPresenter] presentWithText:NLocalizedStr(@"NetworkWiFi") dismissAfterDelay:1.1f includedStyle:JDStatusBarNotificationIncludedStyleDefaultStyle];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NNotificationReloadData" object:nil];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark -- 网络请求配置 --
- (void)initNetwork {
    [[NYSKitManager sharedNYSKitManager] setHost:APP_BASE_URL];
    [[NYSKitManager sharedNYSKitManager] setToken:NAppManager.token];
    [[NYSKitManager sharedNYSKitManager] setNormalCode:@"200,0"];
    [[NYSKitManager sharedNYSKitManager] setTokenInvalidCode:@"500"];
    [[NYSKitManager sharedNYSKitManager] setTokenInvalidMessage:@"验证失败，请先登录"];
    [[NYSKitManager sharedNYSKitManager] setMsgKey:@"msg,message,error_msg"];
    [[NYSKitManager sharedNYSKitManager] setIsAlwaysShowErrorMsg:YES];
}

#pragma mark - App lifecycle
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 返回app刷新交易记录+余额
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (NAppManager.isLogined)
            [NAppManager loadUserInfoCompletion:nil];
    });
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NNotificationReloadWalletListData" object:nil];
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
