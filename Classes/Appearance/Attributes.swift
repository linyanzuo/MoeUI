//
//  AppearanceAttributes.swift
//  MoeUI
//
//  Created by Zed on 2019/7/30.
//

import UIKit


protocol Attributes {}


internal struct TextAttribute: Attributes {
//    internal static var TextKey: UInt { return 2 }
//    internal static var FontKey: UInt { return 4 }
//    internal static vsar ColorKey: UInt { return 8 }
//    internal static var NumberOfLinesKey: UInt { return 16 }
//    internal static var FirstLineIndentKey: UInt { return 32 }

    internal var text: String?
    internal var font: UIFont?
    internal var color: UIColor?
    internal var numberOfLines: Int?
    internal var firstLineIndent: CGFloat?
}

internal struct BackgroundAttribute: Attributes {
    internal var color: UIColor?
    internal var cornerRadius: CGFloat?
    internal var isMaskCornerRadius: Bool?
}

internal struct ShadowAttribute: Attributes {
    internal var color: UIColor?
    internal var path: CGPath?
    internal var opacity: CGFloat?
}

internal struct BorderAttribute: Attributes {
    internal var color: UIColor?
    internal var width: CGFloat?
    internal var cornerRadius: CGFloat?
}

//internal struct ImageAttribute {
//
//}

//internal struct EventAttribute {
//
//}




