//
//  NYSScrollViewController.swift
//  BaseIOS
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit

class NYSAccountViewController: NYSRootViewController, UITextViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var contentViewH: NSLayoutConstraint!
    
    @IBOutlet weak var protocolT: UITextView!
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
        
        self.oneKeyBtn.addRadius(NAppRadius)
        self.oneKeyBtn.backgroundColor = NAppThemeColor
        self.otherAccountBtn.setTitleColor(NAppThemeColor, for: .normal)
        self.otherAccountBtn.addCornerRadius(NAppRadius, borderWidth: 1, borderColor: NAppThemeColor)
        
        let protocolStr: String = "阅读并同意《服务协议》《隐私政策》"
        let attString = NSMutableAttributedString(string: protocolStr)
        attString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: protocolStr.count))
        attString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: 0, length: protocolStr.count))
        let range1 = (protocolStr as NSString).range(of: "《服务协议》")
        let range2 = (protocolStr as NSString).range(of: "《隐私政策》")
        attString.addAttribute(NSAttributedString.Key.link, value: "service://", range: range1)
        attString.addAttribute(NSAttributedString.Key.link, value: "privacy://", range: range2)
        protocolT.linkTextAttributes = [NSAttributedString.Key.foregroundColor: NAppThemeColor]
        protocolT.delegate = self
        protocolT.attributedText = attString
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
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "service" {
            let webVC = NYSWebViewController.init()
            webVC.urlStr = "https://example.com/"
            self.navigationController?.pushViewController(webVC, animated: true)
            
        } else if URL.scheme == "privacy" {
            let webVC = NYSWebViewController.init()
            webVC.urlStr = "https://example.com/"
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        
        return true
    }
}