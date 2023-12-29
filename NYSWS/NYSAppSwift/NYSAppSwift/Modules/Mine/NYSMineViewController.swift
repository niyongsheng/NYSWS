//
//  NYSMineViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/26.
//

import UIKit
import NYSUIKit

class NYSMineViewController: NYSBaseViewController, UIScrollViewDelegate {

    let NAVBAR_COLORCHANGE_POINT:CGFloat = 100
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var contentViewH: NSLayoutConstraint!
    
    @IBOutlet weak var iconIV: UIButton!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var subtitleL: UILabel!
    
    @IBOutlet weak var bannerBgV: UIView!
    
    @IBOutlet weak var oneSV: UIStackView!
    @IBOutlet weak var twoSV: UIStackView!
    @IBOutlet weak var threeSV: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的"
        self.scrollView.delegate = self
        bannerBgV.addRadius(10)
        oneSV.addRadius(10)
        twoSV.addRadius(10)
        threeSV.addRadius(10)
        
    }

    override func configTheme() {
        self.scrollView.contentInsetAdjustmentBehavior = .never
        
        self.navBarBackgroundAlpha = 0
        self.navBarTintColor = .clear
        self.navBarTitleColor = .clear
        
        _ = self.contenView.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
            (item as! UIView).backgroundColor = UIColor.init(hexString: "#F0F0F0")
        })
        _ = self.contenView.lee_theme.leeAddCustomConfig(NIGHT, { (item: Any) in
            (item as! UIView).backgroundColor = UIColor.init(hexString: "#101010")
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > NAVBAR_COLORCHANGE_POINT {
            let alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NTopHeight
            self.navBarBackgroundAlpha = alpha
            self.navBarTintColor = UIColor.black.withAlphaComponent(alpha)
            self.navBarTitleColor = UIColor.black.withAlphaComponent(alpha)
            self.statusBarStyle = .default
        } else {
            self.navBarBackgroundAlpha = 0
            self.navBarTintColor = .clear
            self.navBarTitleColor = .clear
            self.statusBarStyle = .lightContent
        }
    }
    
    @IBAction func itemOnclicked(_ sender: UIButton) {
        if sender.tag == 0 {
            let alertVC = UIAlertController.init(title: "退出登录", message: "确定要退出登录吗？", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction.init(title: "确定", style: .destructive) { (action) in
                let rootVC = NYSAccountViewController.init()
                let navVC = NYSBaseNavigationController.init(rootViewController: rootVC)
                UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = navVC
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        } else {
            
        }
    }
    
}
