//
//  NYSSubScrollViewController.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/29.
//

import UIKit

class NYSSubScrollViewController: NYSRootScrollViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.contentInset = UIEdgeInsets(top: pro_subScrollViewContentOffsetY, left: 0, bottom: 0, right: 0)
        
        view.addSubview(self.collectionView)
        
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

}

extension NYSSubScrollViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 滚动转发
        subScrollViewDidScroll(scrollView)
    }
}
