//
//  AppearanceApply.swift
//  MoeUI
//
//  Created by Zed on 2019/8/28.
//

import UIKit
import MoeCommon


protocol AppearanceApply where Self: UIView {
    func applyGeneralAttribute()
    func applyBackgroundAttribute()
    func applyTextAttribute()
    func applyImageAttribute()
    func applyShadowAttribute()
    func applyEventAppearance()
}
extension AppearanceApply {
    public func applyAttribute() {
        if appearance.generaler != nil { applyGeneralAttribute() }
        if appearance.backgrounder != nil { applyBackgroundAttribute() }
        if appearance.texters.count > 0 { applyTextAttribute() }
        if appearance.imagers.count > 0 { applyImageAttribute() }
        if appearance.shadower != nil { applyShadowAttribute() }
        if appearance.eventers.count > 0 { applyEventAppearance() }
    }

    // MARK: Attribute apply methods
    public func applyGeneralAttribute() {
        guard let attr = self.appearance.generaler?.attribute
            else { return }

        if attr.frame != nil { self.frame = attr.frame! }
        if attr.alpha != nil { self.alpha = attr.alpha! }
        if attr.userInterfaceEnable != nil { self.isUserInteractionEnabled = attr.userInterfaceEnable! }
    }

    public func applyBackgroundAttribute() {
        guard let attr = self.appearance.backgrounder?.attribute
            else { return }

        guard attr.color != nil else { return }
        self.backgroundColor = attr.color
        if attr.cornerRadius != nil {
            if attr.isMaskCornerRadius == true {
                let maskColor = attr.maskColor ?? self.superview?.backgroundColor
                self.layer.addCornerRadius(attr.cornerRadius!, maskColor: maskColor ?? UIColor.white)
            } else {
                self.layer.cornerRadius = attr.cornerRadius!
            }
        }

        if attr.border?.width ?? 0.0 > 0.0 {
            layer.borderWidth = attr.border!.width!
            layer.borderColor = (attr.border?.color ?? UIColor.black).cgColor
        }

        if let gradient = attr.gradient {
            var cgColors: [CGColor] = []
            for color in gradient.colors {
                cgColors.append(color.cgColor)
            }

            self.gradientLayer.frame = self.layer.bounds
            self.gradientLayer.colors = cgColors
            self.gradientLayer.locations = gradient.locations
            self.gradientLayer.startPoint = gradient.startPoint
            self.gradientLayer.endPoint = gradient.endPoint
            if attr.cornerRadius != nil { gradientLayer.cornerRadius = attr.cornerRadius! }

            self.layer.addSublayer(gradientLayer)
        }
    }

    public func applyTextAttribute() {
        MLog("Attention: ``\(NSStringFromClass(self.classForCoder))` does not support Text attribute")
    }

    public func applyImageAttribute() {
        MLog("Attention: ``\(NSStringFromClass(self.classForCoder))` does not support Image attribute")
    }

    public func applyShadowAttribute() {
        guard let attr = self.appearance.shadower?.attribute, attr.color != nil
            else { return }

        layer.shadowColor = attr.color!.cgColor
        layer.shadowOpacity = attr.opacity ?? 1.0
        layer.shadowOffset = attr.offset ?? CGSize(width: 0, height: 0)
    }

    public func applyEventAppearance() {
        MLog("Attention: ``\(NSStringFromClass(self.classForCoder))` does not support Event attribute")
    }

    // MARK: Layout update methods
    public func updateShadowIfLayoutSubviews() {
        guard let shadower = self.appearance.shadower?.attribute
            else { return }

        if shadower.color != nil {
            let cornerRadius = shadower.cornerRadius ?? 0.0
            let rect = bounds.insetBy(dx: -(shadower.extend?.width ?? 0.0),
                                      dy: -(shadower.extend?.height ?? 0.0))
            if cornerRadius <= 0.0 { layer.shadowPath = UIBezierPath(rect: rect).cgPath }
            else { layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath }
        }
    }

    public func updateGradientIfLayoutSubviews() {
        guard let backgrounder = self.appearance.backgrounder?.attribute
            else { return }

        if backgrounder.gradient != nil {
            self.gradientLayer.frame = self.layer.bounds
        }
    }
}
