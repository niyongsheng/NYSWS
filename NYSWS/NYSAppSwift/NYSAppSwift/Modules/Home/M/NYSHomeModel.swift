//
//  NYSHomeCodable.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/8.
//

import Foundation

class NYSHomeModel: NSObject, Codable {
    
}

struct NYSHomeListModel: Codable {
    let name : String?
    let type : String?
    let date : String?
    let title : String?
    let content : String?
}
