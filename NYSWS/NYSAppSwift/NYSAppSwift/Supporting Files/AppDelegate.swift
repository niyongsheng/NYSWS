//
//  AppDelegate.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/4/23.
//

import UIKit
import NYSUIKit
import IQKeyboardManagerSwift
//import WRNavigationBar

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: NYSBaseWindow?
    
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 初始化导航栏
        WRNavigationBar.defaultNavBarBarTintColor = .white // 背景色
        WRNavigationBar.defaultNavBarTintColor = .black // 图标色
        WRNavigationBar.defaultNavBarTitleColor = .black // 标题色
        WRNavigationBar.defaultStatusBarStyle = .lightContent
        WRNavigationBar.defaultShadowImageHidden = true
        
        // 键盘高度控件
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20.0
        
        // 初始化窗口
        ThemeManager.shared().configTheme()
        window = NYSBaseWindow(frame: UIScreen.main.bounds)
//        let rootVC = NYSAccountViewController()
//        let rootNavVC = NYSBaseNavigationController.init(rootViewController: rootVC)
        window?.rootViewController = NYSTabBarViewController()
        window?.makeKeyAndVisible()
        ThemeManager.shared().initBubble(window!)

        return true
    }
}

