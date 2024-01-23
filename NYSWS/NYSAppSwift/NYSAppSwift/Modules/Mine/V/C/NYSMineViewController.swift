//
//  NYSMineViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/26.
//

import UIKit
import NYSUIKit
import RxSwift
import Kingfisher

class NYSMineViewController: NYSRootViewController, UIScrollViewDelegate {
    
    private let bag = DisposeBag()
    private let userinfoSubject = AppManager.shared.userinfoSubject

    let NAVBAR_COLORCHANGE_POINT:CGFloat = 100
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contenView: UIView!
    
    @IBOutlet weak var iconIV: UIButton!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var subtitleL: UILabel!
    
    @IBOutlet weak var lineV: UIView!
    @IBOutlet weak var bannerBgV: UIView!
    
    @IBOutlet weak var oneSV: UIStackView!
    @IBOutlet weak var twoSV: UIStackView!
    @IBOutlet weak var threeSV: UIStackView!
    
    @IBOutlet weak var serviceL: UILabel!
    @IBOutlet weak var serviceTelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的"
        self.scrollView.delegate = self
        self.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNav(self.scrollView)
        AppManager.shared.refreshUserInfo(completion: { isSuccess, userInfo, error in
            if isSuccess {
                self.titleL.text = userInfo?.nickname
                if let firstRole = userInfo?.roleArr.first {
                    self.subtitleL.text = firstRole + " >"
                }
                self.serviceTelBtn.setTitle(userInfo?.tel, for: .normal)
            
            } else {
                self.titleL.text = "未登录"
                self.subtitleL.text = "去认证 >"
                self.serviceTelBtn.setTitle("400-000-0000", for: .normal)
            }
            
            self.iconIV.kf.setImage(with: URL(string: userInfo?.icon ?? ""), for: .normal, placeholder: UIImage.init(named: "pic_48px_def_touxiang"))
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navBarBackgroundAlpha = 1
        navBarBarTintColor = LEETheme.getValueWithTag(LEETheme.currentThemeTag(), identifier: "default_nav_bar_bar_tint_color") as! UIColor
        navBarTintColor = LEETheme.getValueWithTag(LEETheme.currentThemeTag(), identifier: "default_nav_bar_tint_color") as! UIColor
        navBarTitleColor = LEETheme.getValueWithTag(LEETheme.currentThemeTag(), identifier: "default_nav_bar_title_color") as! UIColor
    }
    
    override func setupUI() {
        super.setupUI()
        
        bannerBgV.addRadius(NAppRadius)
        oneSV.addRadius(NAppRadius)
        twoSV.addRadius(NAppRadius)
        threeSV.addRadius(NAppRadius)
        iconIV.addRadius(30)
        
        navBarBackgroundAlpha = 0
        navBarTintColor = .clear
        navBarTitleColor = .clear
        
        if let customFont = UIFont(name: "DOUYU Font", size: 14) {
            serviceL.font = customFont
            serviceTelBtn.titleLabel?.font = customFont
        }
        
    }

    override func configTheme() {
        super.configTheme()
        
        _ = self.lineV.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
            (item as! UIView).backgroundColor = UIColor.init(hexString: "#F0F0F0")
        })
        _ = self.lineV.lee_theme.leeAddCustomConfig(NIGHT, { (item: Any) in
            (item as! UIView).backgroundColor = UIColor.white
        })
        
        _ = self.contenView.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
            (item as! UIView).backgroundColor = UIColor.init(hexString: "#F0F0F0")
        })
        _ = self.contenView.lee_theme.leeAddCustomConfig(NIGHT, { (item: Any) in
            (item as! UIView).backgroundColor = UIColor.init(hexString: "#101010")
        })
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateNav(scrollView)
    }
    
    private func updateNav(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NTopHeight
        if offsetY > NAVBAR_COLORCHANGE_POINT {
            self.navBarBackgroundAlpha = alpha
            if LEETheme.currentThemeTag().contains(DAY) {
                self.navBarTintColor = UIColor.black.withAlphaComponent(alpha)
                self.navBarTitleColor = UIColor.black.withAlphaComponent(alpha)
            } else if LEETheme.currentThemeTag().contains(NIGHT) {
                self.navBarTintColor = UIColor.white.withAlphaComponent(alpha)
                self.navBarTitleColor = UIColor.white.withAlphaComponent(alpha)
            }
            
        } else {
            self.navBarBackgroundAlpha = 0
            self.navBarTintColor = .clear
            self.navBarTitleColor = .clear
        }
    }
    
    @IBAction func itemOnclicked(_ sender: UIButton) {
        if AppManager.shared.isLogin == false {
            AppAlertManager.shared.showLogin()
            return
        }
        
        if sender.tag == 100 {
            let webVC = NYSRootWebViewController.init()
            webVC.urlStr = "https://github.com/niyongsheng/NYSWS/tree/main/NYSWS/"
            self.navigationController?.pushViewController(webVC, animated: true)
             
        } else if sender.tag == 101 {
            self.navigationController?.pushViewController(NYSQRCodeViewController.init(), animated: true)
            
        } else if sender.tag == 102 {
            self.navigationController?.pushViewController(NYSSettingViewController.init(), animated: true)
            
        } else if sender.tag == 103 {
            AppAlertManager.shared.showShare(content: nil)
            
        } else if sender.tag == 104 {
            let webVC = NYSRootWebViewController.init()
            webVC.urlStr = "https://github.com/niyongsheng/NYSWS/issues/new"
            self.navigationController?.pushViewController(webVC, animated: true)
            
        } else if sender.tag == 200 {
            AppAlertManager.shared.showOverdueAlert(text: "未完成基础信息认证,未完成基础信息认证,未完成基础信息认证,未完成基础信息认证,", index: 1, inView: nil)
            
        } else if sender.tag == 201 {
            AppAlertManager.shared.showOverdueAlert(text: "未完成驾驶信息认证", index: 2, inView: nil)
            
        } else if sender.tag == 202 {
            AppAlertManager.shared.showOverdueAlert(text: "未完成车辆信息认证", index: 3, inView: nil)
            
        } else {
            let webVC = NYSRootWebViewController.init()
            webVC.urlStr = "https://niyongsheng.github.io/pixel_homepage/"
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    @IBAction func serviceTelBtnOnclicked(_ sender: UIButton) {
        guard let telURL = URL(string: "tel://" + (AppManager.shared.userInfo.tel ?? ""))  else {
            return
        }
        
        if UIApplication.shared.canOpenURL(telURL) {
            UIApplication.shared.open(telURL, options: [:], completionHandler: nil)
        } else {
            print("无法呼叫电话")
        }
    }
    
}
