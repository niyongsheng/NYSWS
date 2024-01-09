//
//  UITableView+Extension
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit

extension UITableView {
    
    func reloadData(animationType: XSTableViewAnimationType) {
        self.reloadData()
        TableViewAnimationKit.show(with: animationType, tableView: self)
    }
    
}
