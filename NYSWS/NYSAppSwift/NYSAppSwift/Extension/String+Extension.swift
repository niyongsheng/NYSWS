//
//  String+Extension.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import Foundation

extension String {
    
    static func isBlank(string: String?) -> Bool {
        guard let value = string else { return true }
        return value.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
