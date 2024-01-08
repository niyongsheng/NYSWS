//
//  NYSHomeListCell.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/8.
//

import UIKit

@objc(NYSHomeListCell)
class NYSHomeListCell: FlexBaseTableCell {

    @objc var head : UIImageView!
    @objc var name : UILabel!
    @objc var type : UILabel!
    @objc var date : UILabel!
    @objc var title : UILabel!
    @objc var content : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data : NYSHomeListModel, height:Bool) -> Void {
        if(!height){
            name.text = data.name
            type.text = data.type
            date.text = data.date
            title.text = data.title
        }
        content.text = data.content
    }
}
