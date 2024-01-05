//
//  NYSSettingViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/29.
//

import UIKit

class NYSSettingViewController: NYSRootViewController {

    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "设置"
        
        self.logoutBtn.setTitleColor(NAppThemeColor, for: .normal)
        self.logoutBtn.addCornerRadius(NAppRadius, borderWidth: 1, borderColor: NAppThemeColor)
    }

    @IBAction func logoutBtnOnclicked(_ sender: UIButton) {
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
