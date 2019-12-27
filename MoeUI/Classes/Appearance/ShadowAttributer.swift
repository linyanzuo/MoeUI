//
//  ShadowAttributer.swift
//  MoeUI
//
//  Created by Zed on 2019/8/3.
//

import UIKit


internal struct ShadowAttribute: AppearanceAttribute {
    internal var opacity: Float?
    internal var cornerRadius: CGFloat?
    internal var offset: CGSize?
    internal var extend: CGSize?
    internal var color: UIColor?
    internal var path: CGPath?
}


public class ShadowAttributer: AppearanceAttributer, Codable {
    @discardableResult
    public func opacity(_ opacity: Float) -> Self {
        attribute.opacity = opacity
        return self
    }

    @discardableResult
    public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        attribute.cornerRadius = cornerRadius
        return self
    }

    @discardableResult
    public func offset(_ offset: CGSize) -> Self {
        attribute.offset = offset
        return self
    }

    @discardableResult
    public func extend(_ extend: CGSize) -> Self {
        attribute.extend = extend
        return self
    }

    @discardableResult
    public func color(_ color: UIColor) -> Self {
        attribute.color = color
        return self
    }

    @discardableResult
    public func path(_ path: CGPath) -> Self {
        attribute.path = path
        return self
    }

    // MARK: Getter & Setter
    private(set) lazy var attribute: ShadowAttribute = { return ShadowAttribute() }()
}
