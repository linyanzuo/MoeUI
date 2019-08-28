//
//  TextAttributer.swift
//  MoeUI
//
//  Created by Zed on 2019/8/3.
//

import UIKit


internal struct TextAttribute: AppearanceAttribute {
    internal var text: String?
    internal var font: UIFont?
    internal var color: UIColor?
    internal var numberOfLines: Int?
    internal var firstLineIndent: CGFloat?
    internal var state: UIControl.State?
}


public class TextAttributer: AppearanceAttributer, Codable {
    @discardableResult
    public func text(_ text: String, state: UIControl.State = .normal) -> Self {
        attribute.text = text
        attribute.state = state
        return self
    }

    @available (iOS 9.0, *)
    @discardableResult
    public func font(_ size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        attribute.font = UIFont.systemFont(ofSize: size, weight: weight)
        return self
    }

    @discardableResult
    public func color(_ color: UIColor) -> Self {
        attribute.color = color
        return self
    }

    @discardableResult
    public func color(_ rgb: UInt32) -> Self {
        return color(UIColor(rgb: rgb))
    }

    @discardableResult
    public func lines(_ number: Int) -> Self {
        attribute.numberOfLines = number
        return self
    }

    @available (iOS 11.0, *)
    @discardableResult
    public func firstLineIndent(_ indent: CGFloat) -> Self {
        attribute.firstLineIndent = indent
        return self
    }

    // MARK: -- Deprecated Attributes
    @available(*, deprecated, message:"Use newer `text(_ text:)`")
    @discardableResult
    public func title(_ text: String, font: UIFont? = nil) -> Self {
        attribute.text = text
        attribute.font = font
        return self
    }

    // MARK: Getter & Setter
    private(set) lazy var attribute: TextAttribute = { return TextAttribute() }()
}
