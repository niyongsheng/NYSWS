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
        // 初始化窗口
        ThemeManager.shared().configTheme()
        window = NYSBaseWindow(frame: UIScreen.main.bounds)
        let rootVC = NYSAccountViewController()
        window?.rootViewController = NYSBaseNavigationController.init(rootViewController: rootVC)
        window?.makeKeyAndVisible()
        ThemeManager.shared().initBubble(window!)
        
        // 初始化导航栏
        // 设置导航栏默认的背景颜色
        WRNavigationBar.defaultNavBarBarTintColor = UIColor.init(red: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
        // 设置导航栏所有按钮的默认颜色
        WRNavigationBar.defaultNavBarTintColor = .white
        // 设置导航栏标题默认颜色
        WRNavigationBar.defaultNavBarTitleColor = .white
        WRNavigationBar.defaultStatusBarStyle = .lightContent
        WRNavigationBar.defaultShadowImageHidden = true
        
        // 键盘高度控件
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20.0


        return true
    }
}

