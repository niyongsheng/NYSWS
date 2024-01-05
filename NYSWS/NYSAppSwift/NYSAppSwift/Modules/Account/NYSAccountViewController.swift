//
//  NYSScrollViewController.swift
//  BaseIOS
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit

class NYSAccountViewController: NYSRootViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var contentViewH: NSLayoutConstraint!
    
    @IBOutlet weak var oneKeyBtn: UIButton!
    @IBOutlet weak var otherAccountBtn: UIButton!
    @IBOutlet weak var agreeBtnBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.isHidenNaviBar = true
        navBarBackgroundAlpha = 0
        self.scrollView.contentInsetAdjustmentBehavior = .never
        
        self.oneKeyBtn.addRadius(NAppRadius)
        self.oneKeyBtn.backgroundColor = NAppThemeColor
        self.otherAccountBtn.setTitleColor(NAppThemeColor, for: .normal)
        self.otherAccountBtn.addCornerRadius(NAppRadius, borderWidth: 1, borderColor: NAppThemeColor)
    }
    
    override func configTheme() {
        super.configTheme()
        
    }
    
    @IBAction func oneKeyBtnOnclicked(_ sender: UIButton) {
        AppManager.shared.showAlert(title: "未检测到SIM卡")
    }
    
    @IBAction func otherAccountBtnOnclicked(_ sender: UIButton) {
        if !self.agreeBtnBtn.isSelected {
            NYSTools.shakeAnimation(self.agreeBtnBtn.layer)
            return
        }
        self.navigationController?.pushViewController(NYSLoginViewController(), animated: true)
    }
    
    @IBAction func agreeBtnOnclicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func wechatBtnOnclicked(_ sender: UIButton) {
        
    }
    
    @IBAction func appleBtnOnclicked(_ sender: UIButton) {
        
    }
}
