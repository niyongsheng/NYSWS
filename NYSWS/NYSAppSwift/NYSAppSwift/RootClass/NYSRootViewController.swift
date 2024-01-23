//
//  NYSRootViewController.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit

class NYSRootViewController: NYSBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func configTheme() {
        super.configTheme()
        
        _ = self.lee_theme.leeAddCustomConfig(DAY, { (item: Any) in
            (item as! NYSRootViewController).navBarBarTintColor = .white
            (item as! NYSRootViewController).navBarTintColor = .black
            (item as! NYSRootViewController).navBarTitleColor = .black
        })
        _ = self.lee_theme.leeAddCustomConfig(NIGHT, { (item: Any) in
            (item as! NYSRootViewController).navBarBarTintColor = .black
            (item as! NYSRootViewController).navBarTintColor = .white
            (item as! NYSRootViewController).navBarTitleColor = .white
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
