//
//  UIButton+Appearance.swift
//  MoeUI
//
//  Created by Zed on 2019/7/30.
//

import UIKit


extension UIButton {
    override func applyTextAppearance() {
        for texter in appearance.texters {
            let attr = texter.attribute
            let state = attr.state ?? .normal
            if attr.text != nil { setTitle(attr.text, for: state) }
            if attr.color != nil { setTitleColor(attr.color, for: state) }
            if attr.font != nil { titleLabel?.font = attr.font }
        }
    }

    override func applyImageAppearance() {
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

    // MARK: Runtime Method
    public override class func swizzleLayoutSubviews() {
        let originalMethod = class_getInstanceMethod(self.classForCoder(), #selector(UIButton.layoutSubviews))
        let targetMethod = class_getInstanceMethod(self.classForCoder(), #selector(m_button_layoutSubviews))
        guard originalMethod != nil, targetMethod != nil else { return }
        method_exchangeImplementations(originalMethod!, targetMethod!)
    }

    @objc func m_button_layoutSubviews() {
        self.m_button_layoutSubviews()
        updateShadowIfLayoutSubviews()
        updateGradientIfLayoutSubviews()
    }
}


extension MoeUI {
    public static func makeButton(toView: UIView? = nil, _ closure: AppearanceClosure?) -> UIButton {
        return makeButton(appearance: nil, toView: toView, closure)
    }

    public static func makeButton(appearance: Appearance?, toView: UIView?, _ closure: AppearanceClosure?) -> UIButton {
        let btn = UIButton(type: .custom)
        toView?.addSubview(btn)
        if appearance != nil { btn.appearance = appearance! }
        if closure != nil {
            closure!(btn.appearance)
            btn.applyAppearance()
        }
        return btn
    }

    public static func makeButton(toView: UIView? = nil, with identifier: AppearanceIdentifier) -> UIButton? {
        let appearance = AppearanceManager.shared.dequeue(with: identifier)
        guard appearance != nil else { return nil }

        let btn = UIButton(appearance: appearance!)
        if toView != nil { toView?.addSubview(btn) }
        return btn
    }
}

