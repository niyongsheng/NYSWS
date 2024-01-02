//
//  UIColor+Extension.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import Foundation

extension UIColor {
    
    /// 十六进制颜色创建UIColor
    /// - Parameters:
    ///   - hexString: 色值
    ///   - alpha: 透明度
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var formattedHex = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        formattedHex = formattedHex.replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt64 = 0
        Scanner(string: formattedHex).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 随机色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    

}
