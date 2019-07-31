//
//  UIColor+MoeUI.swift
//  MoeUI
//
//  Created by Zed on 2019/7/23.
//
//  扩展 - Hex颜色

import Foundation

public extension UIColor {
    /// 返回16进制RGB值对应的UIColor实例
    ///
    /// - Parameter rgb: 16进制的RGB值, 如0xFFFFFF
    convenience init(rgb: UInt32) {
        let rgba = rgb << 8 | 0x000000FF

        self.init(rgba: rgba)
    }

    /// 返回f16进制RGBA值对应的UIColor实例
    ///
    /// - Parameter rgba: 16进制的RGBA值, 如0xFFFFFFFF
    convenience init(rgba: UInt32) {
        let red = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let blue = CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
        let alpha = CGFloat(rgba & 0x000000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
