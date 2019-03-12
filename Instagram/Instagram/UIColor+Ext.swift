//
//  UIColor+Ext.swift
//  Instagram
//
//  Created by Owen Henley on 2/22/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit

/// Custom color management file
extension UIColor {

    /// Set induvidual colors to form a custom color
    ///
    /// - Parameters:
    ///   - red: red color code
    ///   - green: green color code
    ///   - blue: blue color code
    ///   - alpha: alpha value
    /// - Returns: Returns specified color values for a custom UIColor
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static let offWhite: UIColor = {
        return UIColor.rgb(red: 240, green: 240, blue: 240)
    }()
}
