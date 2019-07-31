//
//  Appearance.swift
//  MoeUI
//
//  Created by Zed on 2019/7/30.
//

import UIKit

public typealias AppearanceClosure = (_ attr: Attributer) -> Void

@objcMembers public class Attributer: NSObject {

    // MARK: Background Attributes
    @discardableResult
    public func background(hex: UInt32, cornerRadius: CGFloat = 0.0) -> Self {
        return background(color: UIColor(rgb: hex), cornerRadius: cornerRadius)
    }

    @discardableResult
    public func background(color: UIColor, cornerRadius: CGFloat = 0.0, isMaskCornerRadius: Bool = false) -> Self {
        backgroundAttribute.color = color
        backgroundAttribute.isMaskCornerRadius = isMaskCornerRadius
        if cornerRadius > 0.0 { backgroundAttribute.cornerRadius = cornerRadius }
        return self
    }

    // MARK: Text Attributes
    @discardableResult
    public func text(_ text: String, font: UIFont? = nil) -> Self {
        textAttribute.text = text
        return self
    }

    // MARK: Getter & Setter
    private(set) lazy var backgroundAttribute: BackgroundAttribute = { return BackgroundAttribute() }()
    private(set) lazy var textAttribute: TextAttribute = { return TextAttribute() }()
}
