//
//  AppDelegate.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/4/23.
//

import UIKit
import NYSUIKit
import IQKeyboardManagerSwift
#if DEBUG
import CocoaDebug
#endif

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
        #if DEBUG
        ThemeManager.shared().initBubble(window!) // 主题气泡按钮
        showMemory() // 显示内存
        showFPS() // 显示FPS
        #endif
    }
    
    func showFPS() {
        let fpsLabel = YYFPSLabel.init()
        fpsLabel.bottom = NScreenHeight - NBottomHeight - 40
        fpsLabel.right = NScreenWidth - 10
        fpsLabel.sizeToFit()
        window?.addSubview(fpsLabel)
    }

    func showMemory() {
        let memLabel = NYSMemoryLabel.init()
        memLabel.bottom = NScreenHeight - NBottomHeight - 10
        memLabel.right = NScreenWidth - 10
        memLabel.sizeToFit()
        window?.addSubview(memLabel)
    }

}


extension AppDelegate {
    
    /// 获取当前显示的控制器
    func getCurrentViewController() -> UIViewController? {
        var result: UIViewController?
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            let fromView = window.subviews[0]
            
            if let nextResponder = fromView.next {
                if nextResponder.isKind(of: UIViewController.self) {
                    result = nextResponder as? UIViewController
                    
                    if result?.navigationController != nil {
                        result = result?.navigationController
                    }
                } else {
                    result = window.rootViewController
                }
            }
        }
        return result
    }
    
    // MARK: - override Swift `print` method
    public func print<T>(file: String = #file, function: String = #function, line: Int = #line, _ message: T, color: UIColor = .red) {
#if DEBUG
        Swift.print(message)
        _SwiftLogHelper.shared.handleLog(file: file, function: function, line: line, message: message, color: color)
#endif
    }
}
