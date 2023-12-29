//
//  NYSScrollViewController.swift
//  BaseIOS
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit

class NYSAccountViewController: NYSBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var contentViewH: NSLayoutConstraint!
    
    @IBOutlet weak var oneKeyBtn: UIButton!
    @IBOutlet weak var otherAccountBtn: UIButton!
    @IBOutlet weak var agreeBtnBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isHidenNaviBar = true
        self.scrollView.contentInsetAdjustmentBehavior = .never
        
        self.oneKeyBtn.addRadius(10)
        self.otherAccountBtn.addCornerRadius(10, borderWidth: 1, borderColor: .lightGray)
    }
    
    @IBAction func oneKeyBtnOnclicked(_ sender: UIButton) {
        
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
