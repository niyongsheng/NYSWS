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
        // 初始化窗口
        ThemeManager.shared().configTheme()
        window = NYSBaseWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = NYSTabBarViewController()
        window?.makeKeyAndVisible()
        ThemeManager.shared().initBubble(window!)
        
        // 初始化导航栏
        WRNavigationBar.wr_widely()
        WRNavigationBar.wr_setBlacklist(["SpecialController",
                                         "TZPhotoPickerController",
                                         "TZGifPhotoPreviewController",
                                         "TZAlbumPickerController",
                                         "TZPhotoPreviewController",
                                         "TZVideoPlayerController"])
        WRNavigationBar.wr_setDefaultNavBarBarTintColor(.white)
        WRNavigationBar.wr_setDefaultNavBarTintColor(.black)
        WRNavigationBar.wr_setDefaultNavBarTitleColor(.black)
        WRNavigationBar.wr_setDefaultStatusBarStyle(.default)
        WRNavigationBar.wr_setDefaultNavBarShadowImageHidden(true)
        
        // 键盘高度控件
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20.0
        

        


        return true
    }
}

