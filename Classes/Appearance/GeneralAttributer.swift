//
//  GeneralAttributer.swift
//  MoeUI
//
//  Created by Zed on 2019/8/29.
//

import UIKit


internal struct GeneralAttribute: AppearanceAttribute {
    internal var alpha: CGFloat?
}


public class GeneralAttributer: AppearanceAttributer, Codable {
    @discardableResult
    public func alpha(_ alpha: CGFloat) -> Self {
        attribute.alpha = alpha
        return self
    }

    // MARK: Getter & Setter
    private(set) lazy var attribute: GeneralAttribute = { return GeneralAttribute() }()
}
