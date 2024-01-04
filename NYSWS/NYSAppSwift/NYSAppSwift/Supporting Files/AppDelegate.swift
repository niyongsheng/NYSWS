//
//  AppDelegate.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/4/23.
//

import UIKit
import NYSUIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: NYSBaseWindow?
    
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 初始化导航栏
        initNavigationBar()
        
        // 初始化键盘
        initIQKeyboard()
        
        // 初始化窗口
        initWindow()

        return true
    }
}

extension AppDelegate {
    
    private func initNavigationBar() {
        WRNavigationBar.defaultNavBarBarTintColor = .white // 背景色
        WRNavigationBar.defaultNavBarTintColor = .black // 图标色
        WRNavigationBar.defaultNavBarTitleColor = .black // 标题色
        WRNavigationBar.defaultStatusBarStyle = .lightContent
        WRNavigationBar.defaultShadowImageHidden = true
    }
    
    func initIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20.0
    }
    
    func initWindow() {
        ThemeManager.shared().configTheme()
        window = NYSBaseWindow(frame: UIScreen.main.bounds)
        _ = window?.lee_theme.leeConfigBackgroundColor("white_black_color")
        window?.rootViewController = NYSTabBarViewController()
        window?.makeKeyAndVisible()
        ThemeManager.shared().initBubble(window!) // 主题气泡按钮
    }
    
    /// 获取当前显示的控制器
    func getCurrentViewController() -> UIViewController? {
        var result: UIViewController?
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for tmpWin in windows {
                if tmpWin.windowLevel == UIWindow.Level.normal {
                    window = tmpWin
                    break
                }
            }
        }
        let fromView = window?.subviews[0]
        if let nextResponder = fromView?.next {
            if nextResponder.isKind(of: UIViewController.self) {
                result = nextResponder as? UIViewController
                if result?.navigationController != nil {
                    result = result?.navigationController
                }
            } else {
                result = window?.rootViewController
            }
        }
        return result
    }
    
}
