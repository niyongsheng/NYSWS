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
        
        navBarBackgroundAlpha = 0
        self.scrollView.contentInsetAdjustmentBehavior = .never
        
        self.oneKeyBtn.addRadius(10)
        self.otherAccountBtn.addCornerRadius(10, borderWidth: 1, borderColor: .lightGray)
    }
    
    override func configTheme() {
//        super.configTheme()
        
        _ = self.oneKeyBtn.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
            (item as! UIButton).backgroundColor = .black
            (item as! UIButton).setTitleColor(.white, for: .normal)
        })
        _ = self.oneKeyBtn.lee_theme.leeAddCustomConfig(NIGHT, { (item: Any) in
            (item as! UIButton).backgroundColor = UIColor.init(hexString: "#f0f0f0")
            (item as! UIButton).setTitleColor(.darkGray, for: .normal)
        })
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
