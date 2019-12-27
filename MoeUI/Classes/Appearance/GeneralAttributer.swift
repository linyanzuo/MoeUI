//
//  GeneralAttributer.swift
//  MoeUI
//
//  Created by Zed on 2019/8/29.
//

import UIKit


internal struct GeneralAttribute: AppearanceAttribute {
    internal var frame: CGRect?
    internal var alpha: CGFloat?
    internal var userInterfaceEnable: Bool?
}


public class GeneralAttributer: AppearanceAttributer, Codable {
    @discardableResult
    public func frame(_ frame: CGRect) -> Self {
        attribute.frame = frame
        return self
    }

    @discardableResult
    public func alpha(_ alpha: CGFloat) -> Self {
        attribute.alpha = alpha
        return self
    }

    @discardableResult
    public func userInterfaceEnable(_ enable: Bool) -> Self {
        attribute.userInterfaceEnable = enable
        return self
    }

    // MARK: Getter & Setter
    private(set) lazy var attribute: GeneralAttribute = { return GeneralAttribute() }()
}
