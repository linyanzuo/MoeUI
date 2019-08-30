//
//  MoeButton.swift
//  MoeUI
//
//  Created by Zed on 2019/8/28.
//

import UIKit


public class MoeButton: UIButton, AppearanceUnity, AppearanceApply {
    public func applyTextAttribute() {
        for texter in appearance.texters {
            let attr = texter.attribute
            let state = attr.state ?? .normal
            if attr.text != nil { setTitle(attr.text, for: state) }
            if attr.color != nil { setTitleColor(attr.color, for: state) }
            if attr.font != nil { titleLabel?.font = attr.font }
        }
    }

    public func applyImageAttribute() {
        for imager in appearance.imagers {
            let attr = imager.attribute
            if attr.state != nil && attr.image != nil {
                if attr.type == .content { setImage(attr.image, for: attr.state!) }
                if attr.type == .background { setBackgroundImage(attr.image, for: attr.state!)}
            }
            if attr.cornerRadius != nil && attr.image != nil {
                if attr.type == .background {
                    let cornerImage = attr.image!.moe.image(radius: attr.cornerRadius!, size: bounds.size)
                    setBackgroundImage(cornerImage, for: attr.state ?? .normal)
                }
                if attr.type == .content && imageView != nil && imageView?.bounds.size != .zero {
                    let cornerImage = attr.image!.moe.image(radius: attr.cornerRadius!, size: imageView!.bounds.size)
                    setImage(cornerImage, for: attr.state ?? .normal)
                }
            }
        }
    }

    public func applyEventAppearance() {
        for eventer in appearance.eventers {
            let attr = eventer.attribute
            if let target = attr.target, let action = attr.action, let controlEvents = attr.controlEvents {
                self.addTarget(target, action: action, for: controlEvents)
            }
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientIfLayoutSubviews()
        updateShadowIfLayoutSubviews()
    }

    // MARK: Layout update Method
    private func updateShadowIfLayoutSubviews() {
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

    private func updateGradientIfLayoutSubviews() {
        guard let backgrounder = self.appearance.backgrounder?.attribute
            else { return }

        if backgrounder.gradient != nil {
            self.gradientLayer.frame = self.layer.bounds
        }
    }
}


extension MoeUI {
    public class func makeButton(toView: UIView? = nil, _ closure: AppearanceClosure?) -> MoeButton {
        let btn = MoeButton(frame: .zero)
        toView?.addSubview(btn)
        if closure != nil {
            closure!(btn.appearance)
            btn.applyAttribute()
        }
        return btn
    }

    public class func makeButton(toView: UIView? = nil, with appearance: Appearance) -> MoeButton {
        let btn = MoeButton(appearance: appearance)
        toView?.addSubview(btn)
        return btn
    }

    public class func makeButton(toView: UIView? = nil, with identifier: AppearanceIdentifier) -> MoeButton? {
        let appearance = AppearanceManager.shared.dequeue(with: identifier)
        guard appearance != nil else { return nil }

        let btn = MoeButton(appearance: appearance!)
        if toView != nil { toView?.addSubview(btn) }
        return btn
    }
}
