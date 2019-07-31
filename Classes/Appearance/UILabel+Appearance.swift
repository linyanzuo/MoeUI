//
//  UIButton+Appearance.swift
//  MoeUI
//
//  Created by Zed on 2019/7/30.
//

import UIKit


extension UILabel {
    override func applyAppearance() {
        applyTextAppearance()
        applyBackgroundAppearance()
    }

    // MARK: Private Method
    private func applyBackgroundAppearance() {
        let attr = self.attributer.backgroundAttribute
        if attr.color != nil { self.layer.backgroundColor = attr.color?.cgColor }
        if attr.cornerRadius != nil {
            if MInfo.phoneVersion >= 11.0 {
                self.layer.cornerRadius = attr.cornerRadius!
            } else {
                let maskColor = self.superview?.backgroundColor ?? UIColor.white
                self.layer.addCornerRadius(attr.cornerRadius!, maskColor: maskColor)
            }
        }
    }

    func applyTextAppearance() {
        let attr = self.attributer.textAttribute
        if attr.text != nil { self.text = attr.text }
        if attr.color != nil { self.textColor = attr.color }
        if attr.font != nil { self.font = attr.font }
        if attr.numberOfLines != nil { self.numberOfLines = attr.numberOfLines! }
        if attr.firstLineIndent != nil {
            let style = NSMutableParagraphStyle()
            style.firstLineHeadIndent = attr.firstLineIndent! * self.font.pointSize;
            style.lineSpacing = 5
            let attrText = NSAttributedString(string: self.text!, attributes: [
                NSAttributedString.Key.paragraphStyle : style
                ])
            self.attributedText = attrText
        }
    }
}


extension MoeUI {
    public static func makeLabel(attributer: Attributer? = nil, toView: UIView? = nil, _ closure: AppearanceClosure?) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        toView?.addSubview(label)
        if attributer != nil { label.attributer = attributer! }
        if closure != nil {
            closure!(label.attributer)
            label.applyAppearance()
        }

        return label
    }
}
