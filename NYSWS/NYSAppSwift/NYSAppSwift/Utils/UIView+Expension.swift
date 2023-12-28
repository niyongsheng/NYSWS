//
//  UIView+Expension.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2023/12/26.
//

import UIKit

extension UIView {
    
    /// 添加圆角
    /// - Parameter radius: 圆角半径
    func addRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    /// 添加圆角边框
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - borderWidth: 边框线宽
    ///   - borderColor: 边框颜色
    func addCornerRadius(_ radius: CGFloat, borderWidth: CGFloat = 1, borderColor: UIColor = .clear) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    /// 添加部分圆角和边框
    /// - Parameters:
    ///   - corners: topLeft | topRight | bottomLeft | bottomRight | allCorners
    ///   - radius: 圆角半径
    ///   - borderWidth: 边框线宽
    ///   - borderColor: 边框颜色
    func addRoundedCorners(corners: UIRectCorner, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        maskLayer.lineWidth = borderWidth
        maskLayer.strokeColor = borderColor.cgColor
        layer.mask = maskLayer
    }
    
    
}

