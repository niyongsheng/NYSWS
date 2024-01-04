//
//  AppManager.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/4.
//

import UIKit

final class AppManager {
    
    /// 是否登录
    private(set) var isLogin: Bool = false
    
    /// 登录弹窗
    private lazy var unloginAlert: AppAlertView = {
        let unloginAlert = AppAlertView(frame: CGRect(x: 0, y: 0, width: NScreenWidth * 0.8, height: RealValueX(x: 165)))
        unloginAlert.configure(title: "温馨提示", content: "您还没有登陆！", icon: nil, confirmButtonTitle: "去登录", cancelBtnTitle: "取消")
        unloginAlert.layoutIfNeeded()
        return unloginAlert
    }()
    
    /// 用户名
    @UserDefault(key: kUsername, defaultValue: nil)
    private(set) var username: String?
    
    /// 角色
    @UserDefault(key: kRole, defaultValue: nil)
    private(set) var role: String?
    
    /// 秘钥
    @UserDefault(key: kToken, defaultValue: nil)
    private(set) var token: String?
    
    /// 用户信息
    private(set) var userInfo: NYSUserInfo?
    
    /// 单例
    static let shared = AppManager()
    
    /// 私有化初始化方法
    private init() {}
    
}

extension AppManager {
    
    enum AppLoginType: Int {
        case unknown = 0           // 未知
        case qq                    // QQ登录
        case weChat                // 微信登录
        case password              // 密码登录
        case oncecode              // 短信登录
        case apple                 // Sign In With Apple
        case verification          // 一键认证
    }
    
    typealias AppManagerCompletion = (Bool, NYSUserInfo?, Error?) -> Void
    
    func loginHandler(loginType: AppLoginType) {
        // 1.获取用户信息
        
        // 2.保存用户信息
        
        // 3.保存登录状态
        isLogin = true
    }
    
    func refreshUserInfo(completion: AppManagerCompletion) {
        // 在此处执行加载用户信息的操作
        
        // 假设加载成功，获取到了 userInfo 对象
        //        userInfo = NYSUserInfo(from: <#Decoder#>)
        
        // 调用闭包，并传递加载结果和用户信息
        completion(true, userInfo, nil)
    }
    
    func logoutHandler() {
        // 1.清除用户信息
        $username.remove()
        $role.remove()
        $token.remove()
        
        // 2.清除登录状态
        isLogin = false
        
        // 3.加载登录页
        
    }
    
}

extension AppManager {
    
    func showLogin() {
        let popup = FFPopup(contentView: unloginAlert, showType: .bounceIn, dismissType: .shrinkOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        unloginAlert.complete = { (action, _) in
            if action == .confirm {
                
                let rootVC = NYSAccountViewController.init()
                let navVC = NYSBaseNavigationController.init(rootViewController: rootVC)
                if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    UIView.transition(with: keyWindow, duration: 0.75, options: .transitionCrossDissolve, animations: {
                        keyWindow.rootViewController = navVC
                    }, completion: nil)
                }
                
            } else {
                popup.dismiss(animated: true)
            }
        }
        popup.show(layout: FFPopupLayout(horizontal: .center, vertical: .center))
    }
    
}
