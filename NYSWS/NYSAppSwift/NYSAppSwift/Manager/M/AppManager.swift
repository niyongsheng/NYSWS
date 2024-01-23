//
//  AppManager.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/4.
//
//  应用信息管理器

import UIKit
import NYSKit
import NYSUIKit
import RxSwift
import ExCodable
import Disk

final class AppManager {
    
    /// 用户信息
    private(set) var userInfo: NYSUserInfo = {
        if let userinfo = try? Disk.retrieve("userinfo.json", from: .documents, as: NYSUserInfo.self) {
            return userinfo
        }
        return NYSUserInfo()
    }() {
        didSet {
            try? Disk.save(userInfo, to: .documents, as: "userinfo.json")
            userinfoSubject.onNext(userInfo)
        }
    }
    
    var seq: Int = 0
    let userinfoSubject = PublishSubject<NYSUserInfo>()
    private let disposeBag = DisposeBag()
    
    /// 是否登录
    var isLogin: Bool {
        return !String.isBlank(string: self.token)
    }
    
    /// 秘钥
    @UserDefault(key: kToken, defaultValue: nil)
    private(set) var token: String?
    
    /// 单例
    static let shared = AppManager()
    
    /// 私有化初始化方法
    private init() {
        _ = AppAlertManager.shared

        NotificationCenter.default.rx.notification(Notification.Name(rawValue: NNotificationTokenInvalidation)).subscribe(onNext: { notification in
            AppAlertManager.shared.showLogin()
        }).disposed(by: disposeBag)
    }
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
    
    typealias AppManagerCompletion = ((_ isSuccess:Bool, _ userInfo:NYSUserInfo?, _ error:Error?) -> Void)?
    
    /// 登入
    func loginHandler(loginType: AppLoginType, params: [String: Any], completion: AppManagerCompletion) {
    
        NYSNetRequest.mockRequest(withParameters: "login_data.json", 
                                  isCheck: true,
                                  remark: "登录",
                                  success: { [weak self] response in
            self?.token = response!["token"] as? String
            completion?(true, nil, nil)
            
        }, failed:{ error in
            completion?(false, nil, nil)
            NYSTools.log("Error: \(String(describing: error))")
        })
    }
    
    /// 登出
    func logoutHandler() {
        // 1.清除Token
        $token.remove()
        NYSKitManager.shared().token = nil
        try? Disk.clear(.documents)
        
        // 2.清除标签别名
        JPUSHService.cleanTags(nil, seq: self.seq)
        JPUSHService.deleteAlias(nil, seq: self.seq)
        
        // 3.加载登录页
        let rootVC = NYSAccountViewController.init()
        let navVC = NYSBaseNavigationController.init(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController?.present(navVC, animated: true, completion: nil)
        }
    }
}

extension AppManager {
    
    /// 刷新用户信息
    /// - Parameter completion: 完成回调
    func refreshUserInfo(completion: AppManagerCompletion) {
        if !isLogin {
            completion?(false, nil, nil)
            return
        }
        
        NYSNetRequest.mockRequest(withParameters: "userinfo_data.json",
                                  isCheck: true,
                                  remark: "重载用户信息",
                                  success: { [weak self] response in
            
            do {
                let userinfo = try response?.decoded() as NYSUserInfo?
                self?.userInfo = userinfo ?? NYSUserInfo()
    
                let tagSet: Set<String> = Set(userinfo!.tagArr)
                JPUSHService.setTags(tagSet, completion: { resultCode, tags, seq in
                    NYSTools.log("设置标签：\(resultCode == 0 ? "成功" : "失败")")
                }, seq: self?.seq ?? 0)

                JPUSHService.setAlias(userinfo!.alias, completion: { resultCode, tags, seq in
                    NYSTools.log("设置别名：\(resultCode == 0 ? "成功" : "失败")")
                }, seq: self?.seq ?? 0)
                
                completion?(true, self?.userInfo, nil)
                
            } catch {
                AppAlertManager.shared.showAlert(title: "解码失败：\(error)")
            }
            
        }, failed:{ error in
            completion?(false, nil, nil)
            NYSTools.log("Error: \(String(describing: error))")
        })
    }
    
}
