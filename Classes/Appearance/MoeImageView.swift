//
//  MoeImageView.swift
//  MoeUI
//
//  Created by Zed on 2019/8/28.
//

import UIKit


open class MoeImageView: UIImageView, AppearanceUnity, AppearanceApply {
    public func applyImageAttribute() {
        for imager in appearance.imagers {
            let attr = imager.attribute
            guard attr.state == .normal else {
                MLog("Attention: `\(NSStringFromClass(self.classForCoder))` only support image attribute which is `normal")
                return
            }

            if attr.image != nil { self.image = attr.image }
            if attr.cornerRadius != nil {
                if MInfo.phoneVersion >= 11.0 && self.appearance.shadower?.attribute.color == nil {
                    layer.masksToBounds = true
                    layer.cornerRadius = attr.cornerRadius!
                } else { addCornerRadius(attr.cornerRadius!) }
            }
        }
    }

    public func applyShadowAttribute() {
        guard let attr = self.appearance.shadower?.attribute, attr.color != nil
            else { return }

        layer.shadowColor = attr.color!.cgColor
        layer.shadowOpacity = attr.opacity ?? 1.0
        layer.shadowOffset = attr.offset ?? CGSize(width: 0, height: 0)
        layer.masksToBounds = false
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientIfLayoutSubviews()
        updateShadowIfLayoutSubviews()
    }
}


extension MoeUI {
    public class func makeImageView(toView: UIView? = nil, _ closure: AppearanceClosure?) -> MoeImageView {
        let imgView = MoeImageView(frame: .zero)
        toView?.addSubview(imgView)
        if closure != nil {
            closure!(imgView.appearance)
            imgView.applyAttribute()
        }
        return imgView
    }

    public class func makeImageView(toView: UIView? = nil, with appearance: Appearance) -> MoeImageView {
        let imgView = MoeImageView(appearance: appearance)
        toView?.addSubview(imgView)
        return imgView
    }

    public class func makeImageView(toView: UIView? = nil, with identifier: AppearanceIdentifier) -> MoeImageView? {
        let appearance = AppearanceManager.shared.dequeue(with: identifier)
        guard appearance != nil else { return nil }

        let imgView = MoeImageView(appearance: appearance!)
        if toView != nil { toView?.addSubview(imgView) }
        return imgView
    }
}
