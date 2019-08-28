//
//  UIImageView+Appearance.swift
//  MoeUI
//
//  Created by Zed on 2019/8/3.
//

import UIKit


extension UIImageView {
    override func applyImageAppearance() {
        for imager in appearance.imagers {
            let attr = imager.attribute
            guard attr.state == .normal else {
                MLog("请注意: `\(NSStringFromClass(self.classForCoder))`只支持`normal`状态的图片样式配置, 其余无效")
                return
            }

            if attr.image != nil { self.image = attr.image }
            if attr.cornerRadius != nil {
            // iOS11后, 使用`maskToBounds = true`可实现不离屏圆角, 但与使用阴影时(`maskToBounds = true`)冲突
//                if MInfo.phoneVersion >= 11.0 {
//                    layer.masksToBounds = true
//                    layer.cornerRadius = attr.cornerRadius!
//                } else { addCornerRadius(attr.cornerRadius!) }
                addCornerRadius(attr.cornerRadius!)
            }
        }
    }

    override func applyShadowAppearance() {
        super.applyShadowAppearance()
        layer.masksToBounds = false
    }

    // MARK: Runtime Method
    public override class func swizzleLayoutSubviews() {
        let originalMethod = class_getInstanceMethod(self.classForCoder(), #selector(UIImageView.layoutSubviews))
        let targetMethod = class_getInstanceMethod(self.classForCoder(), #selector(m_imgView_layoutSubviews))
        guard originalMethod != nil, targetMethod != nil else { return }
        method_exchangeImplementations(originalMethod!, targetMethod!)
    }

    @objc func m_imgView_layoutSubviews() {
        self.m_imgView_layoutSubviews()
        updateShadowIfLayoutSubviews()
    }
}


extension MoeUI {
    public static func makeImageView(toView: UIView? = nil, _ closure: AppearanceClosure?) -> UIImageView {
        return makeImageView(appearance: nil, toView: toView, closure)
    }

    public static func makeImageView(appearance: Appearance?, toView: UIView?, _ closure: AppearanceClosure?) -> UIImageView {
        let imgView = UIImageView(frame: CGRect.zero)
        toView?.addSubview(imgView)
        if appearance != nil { imgView.appearance = appearance! }
        if closure != nil {
            closure!(imgView.appearance)
            imgView.applyAppearance()
        }
        return imgView
    }

    public static func makeImageView(toView: UIView? = nil, with identifier: AppearanceIdentifier) -> UIImageView? {
        let appearance = AppearanceManager.shared.dequeue(with: identifier)
        guard appearance != nil else { return nil }

        let imgView = UIImageView(appearance: appearance!)
        if toView != nil { toView?.addSubview(imgView) }
        return imgView
    }
}
