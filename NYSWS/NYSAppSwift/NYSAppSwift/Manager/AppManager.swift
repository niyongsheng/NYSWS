//
//  AppManager.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/4.
//

import UIKit
import NYSKit
import RxSwift
import ExCodable

final class AppManager {
    
    /// 是否登录
    var isLogin: Bool {
        return !String.isBlank(string: self.token)
    }
    
    /// 秘钥
    @UserDefault(key: kToken, defaultValue: nil)
    private(set) var token: String?
    
    /// 用户信息
    private(set) var userInfo: NYSUserInfo?
    var seq: Int = 0
    let userinfoSubject = PublishSubject<NYSUserInfo>()
    
    /// 登录弹窗
    private lazy var appAlertView: AppAlertView = {
        let appAlertView = AppAlertView(frame: CGRect(x: 0, y: 0, width: NScreenWidth * 0.8, height: RealValueX(x: 165)))
        return appAlertView
    }()
    
    /// 分享弹窗
    private lazy var appShareView: AppShareView = {
        let appShareView = AppShareView(frame: CGRect(x: 0, y: 0, width: NScreenWidth, height: RealValueX(x: 265)))
        return appShareView
    }()
    
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
    
    typealias AppManagerCompletion = ((_ isSuccess:Bool, _ userInfo:NYSUserInfo?, _ error:Error?) -> Void)?
    
    func loginHandler(loginType: AppLoginType, params: [String: Any], completion: AppManagerCompletion) {
    
        NYSNetRequest.mockRequest(withParameters: "login_data.json", 
                                  isCheck: true,
                                  remark: "登录",
                                  success: { [weak self] response in
            self?.token = response!["token"] as? String
            completion?(true, nil, nil)
            
        }, failed:{ error in
            completion?(false, nil, nil)
            print("Error: \(String(describing: error))")
        })
    }
    
    func refreshUserInfo(completion: AppManagerCompletion) {
        if !isLogin {
            completion?(false, nil, nil)
            return
        }
        
        NYSNetRequest.mockRequest(withParameters: "userinfo_data.json",
                                  isCheck: true,
                                  remark: "登录",
                                  success: { [weak self] response in
            
            do {
                let userinfo = try response?.decoded() as NYSUserInfo?
                self?.userInfo = userinfo
    
                let tagSet: Set<String> = Set(userinfo!.tagArr)
                JPUSHService.setTags(tagSet, completion: { resultCode, tags, seq in
                    print("设置标签：\(resultCode == 0 ? "成功" : "失败")")
                }, seq: self?.seq ?? 0)

                JPUSHService.setAlias(userinfo!.aliasArr.first, completion: { resultCode, tags, seq in
                    print("设置别名：\(resultCode == 0 ? "成功" : "失败")")
                }, seq: self?.seq ?? 0)
                
                self?.userinfoSubject.onNext(userinfo!)
                completion?(true, self?.userInfo, nil)
                
            } catch {
                self?.userinfoSubject.onError(error)
                AppManager.shared.showAlert(title: "解码失败：\(error)")
            }
            
        }, failed:{ error in
            completion?(false, nil, nil)
            print("Error: \(String(describing: error))")
        })
    }
    
    func logoutHandler() {
        // 1.清除Token
        $token.remove()
        
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

/// App弹框提醒
extension AppManager {
    
    func showLogin() {
        showAlert(title: "温馨提示", content: "您还没有登陆！", icon: nil, confirmButtonTitle: "去登录", cancelBtnTitle: "取消") { popup, action, obj in
            if action == .confirm {
                popup.dismiss(animated: true)
                self.logoutHandler()
            }
        }
    }
    
    func showAlert(title: String?) {
        showAlert(title: title, content: nil, icon: nil, confirmButtonTitle: "确定", cancelBtnTitle: nil, complete: nil)
    }

    func showAlert(title: String?, complete: ((FFPopup, AppAlertView.AppAlertAction, Any?) -> Void)? = nil) {
        showAlert(title: title, content: nil, icon: nil, confirmButtonTitle: "确定", cancelBtnTitle: nil, complete: complete)
    }

    func showAlert(title: String?, content: String?, icon: UIImage?, confirmButtonTitle: String?, cancelBtnTitle: String?, complete: ((FFPopup, AppAlertView.AppAlertAction, Any?) -> Void)? = nil) {
        
        let popup = FFPopup(contentView: appAlertView, showType: .bounceIn, dismissType: .shrinkOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.showInDuration = 0.3
        popup.show(layout: FFPopupLayout(horizontal: .center, vertical: .center))
        
        appAlertView.popup = popup
        appAlertView.complete = complete
        appAlertView.configure(title: title, content: content, icon: icon, confirmButtonTitle: confirmButtonTitle, cancelBtnTitle: cancelBtnTitle)
        
        let w = appAlertView.width - 30.0
        let titleHeight = title?.heightWithConstrainedWidth(width: w, font: UIFont.boldSystemFont(ofSize: 16)) ?? 0
        let contentHeight = content?.heightWithConstrainedWidth(width: w, font: UIFont.systemFont(ofSize: 17)) ?? 0
        appAlertView.height = 125.0 + (icon?.size.height ?? 0) + titleHeight + contentHeight
    }
    
    func showShare(content: Any?) {
        showShare(content: content, icon: nil, confirmButtonTitle: "分享", complete: nil)
    }
    
    func showShare(content: Any?, icon: UIImage?, confirmButtonTitle: String?, complete: ((FFPopup, AppShareView.AppShareAction, AppShareView.AppShareType, Any?) -> Void)? = nil) {
        
        let popup = FFPopup(contentView: appShareView, showType: .slideInFromBottom, dismissType: .slideOutToBottom, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.showInDuration = 0.3
        popup.show(layout: FFPopupLayout(horizontal: .center, vertical: .bottom))
        
        appShareView.popup = popup
        appShareView.complete = complete
        appShareView.configure(content: nil, icon: nil, confirmButtonTitle: "立即分享")
    }
}
