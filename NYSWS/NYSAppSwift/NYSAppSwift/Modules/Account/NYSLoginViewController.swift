//
//  NYSScrollViewController.swift
//  BaseIOS
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit

class NYSLoginViewController: NYSRootViewController {

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
        
        navBarBackgroundAlpha = 0
        self.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    override func setupUI() {
        super.setupUI()

        self.loginBtn.addRadius(NAppRadius)
        self.loginBtn.backgroundColor = NAppThemeColor
        self.accountView.addCornerRadius(NAppRadius/2, borderWidth: 1, borderColor: NAppThemeColor)
        self.passwordView.addCornerRadius(NAppRadius/2, borderWidth: 1, borderColor: NAppThemeColor)
    }
    
    override func configTheme() {
        super.configTheme()
        
    }
    
    @IBAction func seeBtnOnclicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.passwordTF.isSecureTextEntry = !self.passwordTF.isSecureTextEntry
    }

    @IBAction func loginBtnOnclicked(_ sender: UIButton) {
        NYSTools.zoom(toShow: sender.layer)
        
        let rootVC = NYSTabBarViewController()
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            UIView.transition(with: keyWindow, duration: 0.5, options: .transitionCrossDissolve, animations: {
                keyWindow.rootViewController = rootVC
            }, completion: nil)
        }
    }
    
    @IBAction func forgetPwdBtnOnclicked(_ sender: UIButton) {
        
    }
}
