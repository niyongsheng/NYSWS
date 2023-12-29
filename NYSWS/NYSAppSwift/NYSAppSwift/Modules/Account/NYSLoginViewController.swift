//
//  NYSScrollViewController.swift
//  BaseIOS
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit

class NYSLoginViewController: NYSBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var contentViewH: NSLayoutConstraint!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var seeBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "登录"
        self.navBarBackgroundAlpha = 0
//        self.scrollView.contentInsetAdjustmentBehavior = .never
        
        
        self.loginBtn.addRadius(10)
        self.accountView.addCornerRadius(7, borderWidth: 1, borderColor: .lightGray)
        self.passwordView.addCornerRadius(7, borderWidth: 1, borderColor: .lightGray)
    }
    
    @IBAction func seeBtnOnclicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.passwordTF.isSecureTextEntry = !self.passwordTF.isSecureTextEntry
    }

    @IBAction func loginBtnOnclicked(_ sender: UIButton) {
        let rootVC = NYSTabBarViewController.init()
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = rootVC
    }
    
    @IBAction func forgetPwdBtnOnclicked(_ sender: UIButton) {
        
    }
}
