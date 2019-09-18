//
//  BackgroundAttributer.swift
//  MoeUI
//
//  Created by Zed on 2019/8/3.
//

import UIKit


internal struct BackgroundAttribute: AppearanceAttribute {
    internal var color: UIColor?
    internal var image: UIImage?
    internal var cornerRadius: CGFloat?
    internal var maskColor: UIColor?
    internal var isMaskCornerRadius: Bool?
    internal var border: BorderAttribute?
    internal var gradient: GradientAttribute?
}


internal struct BorderAttribute: AppearanceAttribute {
    internal var width: CGFloat?
    internal var color: UIColor?
}


internal struct GradientAttribute: AppearanceAttribute {
    internal var startPoint: CGPoint
    internal var endPoint: CGPoint
    internal var colors: [UIColor]
    internal var locations: [NSNumber]
}


public class BackgroundAttributer: AppearanceAttributer, Codable {
    @discardableResult
    public func background(color: UIColor) -> Self {
        attribute.color = color
        return self
    }

    @discardableResult
    public func background(image: UIImage) -> Self {
        attribute.image = image
        return self
    }

    @discardableResult
    public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        attribute.isMaskCornerRadius = false
        if cornerRadius > 0.0 { attribute.cornerRadius = cornerRadius }
        return self
    }

    @discardableResult
    public func maskCornerRadius(_ cornerRadius: CGFloat, maskColor: UIColor) -> Self {
        guard cornerRadius > 0 else { return self }
        attribute.isMaskCornerRadius = true
        attribute.maskColor = maskColor
        attribute.cornerRadius = cornerRadius
        return self
    }

    @discardableResult
    public func border(_ width: CGFloat, color: UIColor = UIColor.black) -> Self {
        attribute.border = BorderAttribute(width: width, color: color)
        return self
    }

    @discardableResult
    public func gradient(startPoint: CGPoint, endPoint: CGPoint, colors: [UIColor], locations: [NSNumber]) -> Self {
        attribute.gradient = GradientAttribute(startPoint: startPoint, endPoint: endPoint, colors: colors, locations: locations)
        return self
    }

    // MARK: Getter & Setter
    private(set) lazy var attribute: BackgroundAttribute = { return BackgroundAttribute() }()
}
