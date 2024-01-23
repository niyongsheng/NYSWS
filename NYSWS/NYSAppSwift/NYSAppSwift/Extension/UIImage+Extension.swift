//
//  UIImage+Extension
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit

extension UIImage {
    
    func tinted(withColor color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
            return nil
        }
        
        let rect = CGRect(origin: .zero, size: size)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0, y: -size.height)
        context.clip(to: rect, mask: cgImage)
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        if let tintedImage = UIGraphicsGetImageFromCurrentImageContext() {
            return tintedImage
        } else {
            return nil
        }
    }
    
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: size))
        
        if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
            return resizedImage
        } else {
            return nil
        }
    }
}

