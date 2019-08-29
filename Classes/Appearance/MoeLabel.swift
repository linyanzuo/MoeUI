//
//  MoeLabel.swift
//  MoeUI
//
//  Created by Zed on 2019/8/28.
//

import UIKit


public class MoeLabel: UILabel, AppearanceUnity, AppearanceApply {
    public func applyBackgroundAttribute() {
        let attr = self.appearance.backgrounder.attribute
        if attr.color != nil { self.layer.backgroundColor = attr.color?.cgColor }
        if attr.cornerRadius != nil {
            if attr.isMaskCornerRadius == true  {
                let maskColor = attr.maskColor ?? self.superview?.backgroundColor
                layer.addCornerRadius(radius: attr.cornerRadius!,
                                      corner: .allCorners, size: bounds.size,
                                      borderWidth: attr.border?.width ?? 0.0,
                                      borderColor: attr.border?.color ?? UIColor.black,
                                      maskColor: maskColor ?? .white)
            } else {
                layer.masksToBounds = true
                layer.cornerRadius = attr.cornerRadius!
            }
        }
        if attr.border?.width ?? 0.0 > 0.0 {
            layer.borderWidth = attr.border!.width!
            layer.borderColor = (attr.border!.color ?? UIColor.black).cgColor
        }
        if let _ = attr.gradient {
            MLog("Attention: `\(NSStringFromClass(self.classForCoder))` does not support to use gradient layer directly. Please add the label and gradient layer to a UIView")
        }
    }

    public func applyTextAttribute() {
        for texter in appearance.texters {
            let attr = texter.attribute
            guard attr.state == .normal else {
                MLog("Attention: `\(NSStringFromClass(self.classForCoder))` only support text attribute which is `normal` state")
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

    public func applyShadowAttribute() {
        let attr = self.appearance.shadower.attribute
        guard attr.color != nil else { return }

        layer.shadowColor = attr.color!.cgColor
        layer.shadowOpacity = attr.opacity ?? 1.0
        layer.shadowOffset = attr.offset ?? CGSize(width: 0, height: 0)
        layer.masksToBounds = false
    }
}


extension MoeUI {
    public class func makeLabel(toView: UIView? = nil, _ closure: AppearanceClosure?) -> MoeLabel {
        let label = MoeLabel(frame: .zero)
        toView?.addSubview(label)
        if closure != nil {
            closure!(label.appearance)
            label.applyAttribute()
        }
        return label
    }

    public class func makeLabel(toView: UIView?, with appearance: Appearance) -> MoeLabel {
        let label = MoeLabel(appearance: appearance)
        toView?.addSubview(label)
        return label
    }

    public class func makeLabel(toView: UIView? = nil, with identifier: AppearanceIdentifier) -> MoeLabel? {
        let appearance = AppearanceManager.shared.dequeue(with: identifier)
        guard appearance != nil else { return nil }

        let label = MoeLabel(appearance: appearance!)
        if toView != nil { toView?.addSubview(label) }
        return label
    }
}
