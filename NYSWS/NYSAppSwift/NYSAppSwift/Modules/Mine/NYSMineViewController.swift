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
        
        self.wr_setNavBarBackgroundAlpha(0)
        self.wr_setNavBarTintColor(UIColor.white)
        self.wr_setNavBarBarTintColor(UIColor.white)
        
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
            self.wr_setNavBarBackgroundAlpha(alpha)
            self.wr_setNavBarTintColor(UIColor.black.withAlphaComponent(alpha))
            self.wr_setNavBarTitleColor(UIColor.black.withAlphaComponent(alpha))
            self.wr_setStatusBarStyle(.default)
        } else {
            self.wr_setNavBarBackgroundAlpha(0)
            self.wr_setNavBarTintColor(UIColor.white)
            self.wr_setNavBarTitleColor(UIColor.black)
            self.wr_setStatusBarStyle(.lightContent)
        }
    }
}
