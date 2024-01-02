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
    @IBOutlet weak var contentViewH: NSLayoutConstraint!
    
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
    
    override func setupUI() {
        super.setupUI()
        
        bannerBgV.addRadius(10)
        oneSV.addRadius(10)
        twoSV.addRadius(10)
        threeSV.addRadius(10)
        
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
        print("offsetY: \(offsetY)   alpha: \(alpha)")
    }
    
    @IBAction func itemOnclicked(_ sender: UIButton) {
        if sender.tag == 102 {
            self.navigationController?.pushViewController(NYSSettingViewController.init(), animated: true)
        } else {
            let alertVC = UIAlertController.init(title: "退出登录", message: "确定要退出登录吗？", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction.init(title: "确定", style: .destructive) { (action) in
                let rootVC = NYSAccountViewController.init()
                let navVC = NYSBaseNavigationController.init(rootViewController: rootVC)
                if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    UIView.transition(with: keyWindow, duration: 0.75, options: .transitionCrossDissolve, animations: {
                        keyWindow.rootViewController = navVC
                    }, completion: nil)
                }
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            
        }
    }
    
}
