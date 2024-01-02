//
//  NYSHomeListViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/27.
//

import UIKit

class NYSHomeListViewController: NYSRootViewController {
    
    var indexStr: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(self.tableView)
    }

    override func headerRereshing() {
        super.headerRereshing()
    }
    
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -100;
    }
}
