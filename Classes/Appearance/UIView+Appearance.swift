//
//  UIView+Appearance.swift
//  MoeUI
//
//  Created by Zed on 2019/7/30.
//

import UIKit


extension UIView {
    public convenience init(appearance: Appearance) {
        self.init(frame: .zero)
        self.appearance = appearance
        applyAppearance()
    }

    public convenience init(_ closure: AppearanceClosure) {
        self.init(frame: .zero)
        closure(self.appearance)
        applyAppearance()
    }

    func applyAppearance() {
        if appearance.texters.count > 0 { applyTextAppearance() }
        if appearance.imagers.count > 0 { applyImageAppearance() }
        applyBackgroundAppearance()
        applyShadowAppearance()
    }

    @objc public func updateAppearance(_ closure: AppearanceClosure) {
        closure(self.appearance)
        applyAppearance()
    }

    @objc public func resetAppearance(_ closure: AppearanceClosure) {
        self.appearance = Appearance()
        closure(self.appearance)
        applyAppearance()
    }

    public func resetAppearance(identifier: AppearanceIdentifier) {
        guard let appearance = AppearanceManager.shared.dequeue(with: identifier) else {
            MLog("Reset Appearance Fail. Can't find appearance which matches to identifier")
            return
        }

        self.appearance = appearance
        applyAppearance()
    }

    // MARK: Appearance Method
    @objc func applyBackgroundAppearance() {
        let attr = self.appearance.backgrounder.attribute

        guard attr.color != nil else { return }
        self.backgroundColor = attr.color
        if attr.cornerRadius != nil {
            if attr.isMaskCornerRadius == true {
                let maskColor = self.superview?.backgroundColor
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

    @objc func applyTextAppearance() {
        MLog("请注意: `\(NSStringFromClass(self.classForCoder))`不支持文本样式配置")
    }

    @objc func applyImageAppearance() {
        MLog("请注意: `\(NSStringFromClass(self.classForCoder))`不支持图片样式配置")
    }

    @objc func applyShadowAppearance() {
        let attr = self.appearance.shadower.attribute
        guard attr.color != nil else { return }

        layer.shadowColor = attr.color!.cgColor
        layer.shadowOpacity = attr.opacity ?? 1.0
        layer.shadowOffset = attr.offset ?? CGSize(width: 0, height: 0)
    }

    // MARK: Runtime Method
    @objc public class func swizzleLayoutSubviews() {
        let originalMethod = class_getInstanceMethod(self.classForCoder(), #selector(UIView.layoutSubviews))
        let targetMethod = class_getInstanceMethod(self.classForCoder(), #selector(m_view_layoutSubviews))
        guard originalMethod != nil, targetMethod != nil else { return }
        method_exchangeImplementations(originalMethod!, targetMethod!)
    }

    @objc func m_view_layoutSubviews() {
        self.m_view_layoutSubviews()
        updateShadowIfLayoutSubviews()
        updateGradientIfLayoutSubviews()
    }

    // MARK: Layout update Method
    @objc func updateShadowIfLayoutSubviews() {
        let shadower = self.appearance.shadower.attribute
        if shadower.color != nil {
            let cornerRadius = shadower.cornerRadius ?? 0.0
            let rect = bounds.insetBy(dx: -(shadower.extend?.width ?? 0.0),
                                      dy: -(shadower.extend?.height ?? 0.0))
            if cornerRadius <= 0.0 { layer.shadowPath = UIBezierPath(rect: rect).cgPath }
            else { layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath }
        }
    }

    @objc func updateGradientIfLayoutSubviews() {
        let backgrounder = self.appearance.backgrounder.attribute
        if backgrounder.gradient != nil {
            self.gradientLayer.frame = self.layer.bounds
        }
    }
}


extension MoeUI {
    public static func makeView(toView: UIView? = nil, _ closure: AppearanceClosure?) -> MoeView {
        return makeView(appearance: nil, toView: toView, closure)
    }

    public static func makeView(appearance: Appearance?, toView: UIView?, _ closure: AppearanceClosure?) -> MoeView {
        let view = MoeView(frame: CGRect.zero)
        toView?.addSubview(view)
        if appearance != nil { view.appearance = appearance! }
        if closure != nil {
            closure!(view.appearance)
            view.applyAppearance()
        }
        return view
    }

    public static func makeView(toView: UIView? = nil, with appearance: Appearance) -> MoeView {
        let view = MoeView(appearance: appearance)
        if toView != nil { toView?.addSubview(view) }
        return view
    }

    public static func makeView(toView: UIView? = nil, with identifier: AppearanceIdentifier) -> MoeView? {
        let appearance = AppearanceManager.shared.dequeue(with: identifier)
        guard appearance != nil else { return nil }

        let view = MoeView(appearance: appearance!)
        if toView != nil { toView?.addSubview(view) }
        return view
    }
}

