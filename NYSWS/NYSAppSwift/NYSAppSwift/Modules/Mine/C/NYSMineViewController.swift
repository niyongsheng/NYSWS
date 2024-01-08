//
//  NYSMineViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/26.
//

import UIKit
import NYSUIKit

class NYSMineViewController: NYSRootViewController, UIScrollViewDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的"
        self.scrollView.delegate = self
        self.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNav(self.scrollView)
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
        
        navBarBackgroundAlpha = 0
        navBarTintColor = .clear
        navBarTitleColor = .clear
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
        if sender.tag == 100 {
            let webVC = NYSWebViewController.init()
            webVC.urlStr = "https://niyongsheng.github.io/pixel_homepage/"
            self.navigationController?.pushViewController(webVC, animated: true)
             
        } else if sender.tag == 101 {
            self.navigationController?.pushViewController(NYSQRCodeViewController.init(), animated: true)
            
        } else if sender.tag == 102 {
            self.navigationController?.pushViewController(NYSSettingViewController.init(), animated: true)
            
        } else if sender.tag == 103 {
            AppManager.shared.showShare(content: nil)
            
        } else {
            AppManager.shared.showLogin()
        }
    }
    
}