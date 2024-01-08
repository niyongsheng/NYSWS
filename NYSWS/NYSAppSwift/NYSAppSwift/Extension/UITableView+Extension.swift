//
//  UITableView+Extension.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/8.
//

import UIKit

extension UITableView {
    
    func reloadData(animationType: XSTableViewAnimationType) {
        self.reloadData()
        TableViewAnimationKit.show(with: animationType, tableView: self)
    }
    
}
