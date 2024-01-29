//
//  NYSRootViewController.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//
//  *项目中控制器继承公共基类方便统一管理，控制框架抽象的颗粒度。

import UIKit
import RxSwift
import NYSUIKit

class NYSRootViewController: NYSBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func configTheme() {
        super.configTheme()
        
        _ = self.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
            (item as! Self).navBarBarTintColor = .white
            (item as! Self).navBarTintColor = .black
            (item as! Self).navBarTitleColor = .black
        })
        _ = self.lee_theme.leeAddCustomConfig(NIGHT, { (item: Any) in
            (item as! Self).navBarBarTintColor = .black
            (item as! Self).navBarTintColor = .white
            (item as! Self).navBarTitleColor = .white
        })
    }
    
    override func setupUI() {
        super.setupUI()
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
    }
    
}

extension NYSRootViewController {

}
