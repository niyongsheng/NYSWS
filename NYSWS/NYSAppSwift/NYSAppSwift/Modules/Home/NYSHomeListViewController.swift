//
//  NYSHomeListViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/27.
//

import UIKit

class NYSHomeListViewController: NYSBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(self.tableView)
    }

    override func headerRereshing() {
        super.headerRereshing()
    }
    
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -100;
    }
}
