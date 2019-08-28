//
//  UIColor+MoeUI.swift
//  MoeUI
//
//  Created by Zed on 2019/7/23.
//
//  extension - hex color

import UIKit


public extension UIColor {
    /// Return a instance of UIColor, which corresponding to hex RGB value
    ///
    /// - Parameter rgb: hex rgb value, like `0xFFFFFF`
    convenience init(rgb: UInt32) {
        let rgba = rgb << 8 | 0x000000FF

        self.init(rgba: rgba)
    }

    /// Return a instance of UIColor, which corresponding to hex RGBA value
    ///
    /// - Parameter rgba: hex rgb value, like `0xFFFFFFFF`
    convenience init(rgba: UInt32) {
        let red = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let blue = CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
        let alpha = CGFloat(rgba & 0x000000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
