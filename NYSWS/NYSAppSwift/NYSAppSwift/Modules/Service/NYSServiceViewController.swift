//
//  NYSServiceViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/27.
//

import UIKit
import NYSUIKit

class NYSServiceViewController: NYSBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "服务"
        view.addSubview(self.collectionView)
    }
    
//    override func configTheme() {
//        // 主题适配
//        _ = self.view.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
//            (item as! UIView).backgroundColor = .red
//        })
//        _ = self.view.lee_theme.leeAddCustomConfig(NIGHT, { (item: Any) in
//            (item as! UIView).backgroundColor = .green
//        })
//    }

}
