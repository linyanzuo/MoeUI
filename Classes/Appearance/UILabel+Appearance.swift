//
//  UIButton+Appearance.swift
//  MoeUI
//
//  Created by Zed on 2019/7/30.
//

import UIKit


extension UILabel {
    // MARK: Private Method
    override func applyBackgroundAppearance() {
        let attr = self.appearance.backgrounder.attribute
        if attr.color != nil { self.layer.backgroundColor = attr.color?.cgColor }
        if attr.cornerRadius != nil {
            if MInfo.phoneVersion >= 11.0 {
                layer.masksToBounds = true
                layer.cornerRadius = attr.cornerRadius!
                if attr.border?.width ?? 0.0 > 0.0 {
                    layer.borderWidth = attr.border!.width!
                    layer.borderColor = (attr.border!.color ?? UIColor.black).cgColor
                }
            } else {
                var maskColor = attr.maskBackground ?? self.superview?.backgroundColor
                if maskColor == nil { maskColor = UIColor.white }
                layer.addCornerRadius(radius: attr.cornerRadius!,
                                      corner: .allCorners, size: bounds.size,
                                      borderWidth: attr.border?.width ?? 0.0,
                                      borderColor: attr.border?.color ?? UIColor.black,
                                      maskColor: maskColor!)
            }
        }
        if let _ = attr.gradient {
            MLog("Attention: Label does not support to use gradient layer directly. Please add the label and gradient layer to a UIView")
        }
    }

    override func applyTextAppearance() {
        for texter in appearance.texters {
            let attr = texter.attribute
            guard attr.state == .normal else {
                MLog("请注意: `\(NSStringFromClass(self.classForCoder))`只支持`normal`状态的文本样式配置, 其余无效")
                return
            }

            if attr.text != nil { self.text = attr.text }
            if attr.color != nil { self.textColor = attr.color }
            if attr.font != nil { self.font = attr.font }
            if attr.numberOfLines != nil { self.numberOfLines = attr.numberOfLines! }
            if attr.firstLineIndent != nil {
                var attrDict: [NSAttributedString.Key: Any] = [:]
                if attr.color != nil { attrDict[NSAttributedString.Key.foregroundColor] = attr.color! }
                if attr.font != nil { attrDict[NSAttributedString.Key.font] = attr.font }

                let style = NSMutableParagraphStyle()
                style.firstLineHeadIndent = attr.firstLineIndent! * self.font.pointSize;
                style.lineSpacing = 5
                attrDict[NSAttributedString.Key.paragraphStyle] = style

                let attrText = NSAttributedString(string: attr.text ?? "Default", attributes: attrDict)
                self.attributedText = attrText
            }
        }
    }

    override func applyShadowAppearance() {
        super.applyShadowAppearance()
        layer.masksToBounds = false
    }

    // MARK: Runtime Method
    public override class func swizzleLayoutSubviews() {
        let originalMethod = class_getInstanceMethod(self.classForCoder(), #selector(UILabel.layoutSubviews))
        let targetMethod = class_getInstanceMethod(self.classForCoder(), #selector(m_label_layoutSubviews))
        guard originalMethod != nil, targetMethod != nil else { return }
        method_exchangeImplementations(originalMethod!, targetMethod!)
    }

    @objc func m_label_layoutSubviews() {
        self.m_label_layoutSubviews()
        updateShadowIfLayoutSubviews()
        updateGradientIfLayoutSubviews()
    }
}


extension MoeUI {
    public static func makeLabel(toView: UIView? = nil, _ closure: AppearanceClosure?) -> UILabel {
        return makeLabel(appearance: nil, toView: toView, closure)
    }

    public static func makeLabel(appearance: Appearance?, toView: UIView?, _ closure: AppearanceClosure?) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        toView?.addSubview(label)
        if appearance != nil { label.appearance = appearance! }
        if closure != nil {
            closure!(label.appearance)
            label.applyAppearance()
        }
        return label
    }

    public static func makeLabel(toView: UIView? = nil, with identifier: AppearanceIdentifier) -> UILabel? {
        let appearance = AppearanceManager.shared.dequeue(with: identifier)
        guard appearance != nil else { return nil }

        let label = UILabel(appearance: appearance!)
        if toView != nil { toView?.addSubview(label) }
        return label
    }
}
