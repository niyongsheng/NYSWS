//
//  NYSTabBarViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/19.
//

import UIKit
import NYSUIKit

class NYSTabBarViewController: NYSBaseTabBarController, UITabBarControllerDelegate {
    var curSelectedIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.viewControllers = self.createTabBarViewControllers()
        UITabBar.appearance().unselectedItemTintColor = .darkGray
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().tintColor = NAppThemeColor
        
        _ =  self.tabBar.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
            (item as! UITabBar).backgroundColor = .white
        })
        _ =  self.tabBar.lee_theme.leeAddCustomConfig(NIGHT, { (item: Any) in
            (item as! UITabBar).backgroundColor = .black
        })
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        stopTabBarAnimation()
        playTabBarAnimation()
        self.curSelectedIndex = self.selectedIndex
    }
    
    /// Stop Lottie Animation
    func stopTabBarAnimation() {
        for view in tabBar.subviews {
            if let tabBarButton = view as? UIControl, let animationView = tabBarButton.subviews.first as? LOTAnimationView {
                animationView.stop()
                animationView.removeFromSuperview()
            }
        }
    }
    
    /// Play Lottie Animation
    func playTabBarAnimation() {
        if self.selectedIndex == self.curSelectedIndex || self.selectedIndex == 2 {
            return
        }
        
        let tabbarButton = self.tabBar.subviews[self.selectedIndex + 1]
        let animationJsons = ["bill","goods","","service","myself"]
        let animatonView = tabbarButton.subviews.first
        animatonView?.isHidden = true
        let animation = LOTAnimationView(name: animationJsons[self.selectedIndex], bundle: Bundle.main)
        animation.frame = animatonView!.frame
        tabbarButton.addSubview(animation)
        animation.play { animationFinished in
            animatonView?.isHidden = false
            animation.stop()
            animation.removeFromSuperview()
        }
    }
    
    func createTabBarViewControllers() -> [UINavigationController] {
        let oneVC = NYSHomeViewController()
        oneVC.tabBarItem.title = "首页"
        oneVC.tabBarItem.image = UIImage.init(named: "Waybill-white")?.withRenderingMode(.alwaysOriginal)
        oneVC.tabBarItem.selectedImage = UIImage.init(named: "Waybill-green")?.withRenderingMode(.alwaysOriginal)
        let oneNav = NYSBaseNavigationController.init(rootViewController: oneVC)
        
        let twoVC = NYSMissionViewController()
        twoVC.tabBarItem.title = "货源"
        twoVC.tabBarItem.image = UIImage.init(named: "Find-white")?.withRenderingMode(.alwaysOriginal)
        twoVC.tabBarItem.selectedImage = UIImage.init(named: "Find-green")?.withRenderingMode(.alwaysOriginal)
        let twoNav = NYSBaseNavigationController.init(rootViewController: twoVC)
        
        let threeVC = NYSBaseViewController()
        threeVC.tabBarItem.title = ""
        threeVC.tabBarItem.image = UIImage.init(named: "Scan-green")?.withRenderingMode(.alwaysOriginal)
        threeVC.tabBarItem.selectedImage = UIImage.init(named: "Scan-green")?.withRenderingMode(.alwaysOriginal)
        let threeNav = NYSBaseNavigationController.init(rootViewController: threeVC)
        
        let fourVC = NYSServiceViewController()
        fourVC.tabBarItem.title = "服务"
        fourVC.tabBarItem.image = UIImage.init(named: "service-white")?.withRenderingMode(.alwaysOriginal)
        fourVC.tabBarItem.selectedImage = UIImage.init(named: "service-green")?.withRenderingMode(.alwaysOriginal)
        let fourNav = NYSBaseNavigationController.init(rootViewController: fourVC)
        
        let fiveVC = NYSMineViewController()
        fiveVC.tabBarItem.title = "我的"
        fiveVC.tabBarItem.image = UIImage.init(named: "user-white")?.withRenderingMode(.alwaysOriginal)
        fiveVC.tabBarItem.selectedImage = UIImage.init(named: "user-green")?.withRenderingMode(.alwaysOriginal)
        let fiveNav = NYSBaseNavigationController.init(rootViewController: fiveVC)
        
        return [oneNav, twoNav, threeNav, fourNav, fiveNav]
    }
    
}