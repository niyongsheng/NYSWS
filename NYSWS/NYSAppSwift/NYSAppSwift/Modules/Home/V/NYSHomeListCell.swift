//
//  NYSHomeListCell.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/8.
//

import UIKit

@objc(NYSHomeListCell)
class NYSHomeListCell: FlexBaseTableCell {

    @objc private var head : UIImageView!
    @objc private var name : UILabel!
    @objc private var type : UILabel!
    @objc private var date : UILabel!
    @objc private var title : UILabel!
    @objc private var content : UILabel!
    
    var model: NYSHomeListModel! {
        didSet {
            name.text = model.name
            type.text = model.type
            date.text = model.date
            title.text = model.title
            content.text = model.content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
