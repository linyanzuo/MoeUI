//
//  MoeView.swift
//  MoeUIDemo
//
//  Created by Zed on 2019/11/25.
//  Copyright © 2019 www.moemone.com. All rights reserved.
//

import UIKit
import MoeCommon


/// 控件可赋值协议。控件在该协议方法实现中完成赋值器对自身属性的赋值
public protocol ValuationViewProtocol where Self: UIView {
    var designator: Designator { get set }
    func applyValuation(valuatorType: ValuatorType)
    
    func updateDesignator(_ designator: Designator)
    func updateDesign(_ closure: DesignClosure)
    func resetDesign(_ closure: DesignClosure)
}
public extension ValuationViewProtocol {
    func updateDesignator(_ designator: Designator) {
        self.designator = designator
        self.designator.applyValuator(toView: self)
    }
    
    func updateDesign(_ closure: DesignClosure) {
        closure(self.designator)
        designator.applyValuator(toView: self)
    }
    
    func resetDesign(_ closure: DesignClosure) {
        self.designator = Designator()
        closure(designator)
        designator.applyValuator(toView: self)
    }
}


// MARK: 针对`ValuationViewProtocol`的扩展

extension UIView: Runtime {
    
    var KeyDesignator: Key { get { return runtimeKey(for: "Designator")! } }
    var KeyGradientLayer: Key { get { return runtimeKey(for: "GradientLayer")! } }
    
    /// 设计器
    @objc public var designator: Designator {
        get {
            var _designator = getAssociatedObject(for: KeyDesignator) as? Designator
            if _designator == nil {
                _designator = Designator()
                setAssociatedRetainObject(object: _designator, for: KeyDesignator)
            }
            return _designator!
        }
        set { setAssociatedCopyObject(object: newValue, for: KeyDesignator) }
    }
        
    /// 渐变背景图层
    @objc public var gradientLayer: CAGradientLayer {
        get {
            var _gradientLayer = getAssociatedObject(for: KeyGradientLayer) as? CAGradientLayer
            if _gradientLayer == nil {
                _gradientLayer = CAGradientLayer()
                setAssociatedRetainObject(object: _gradientLayer, for: KeyGradientLayer)
            }
            return _gradientLayer!
        }
        set { setAssociatedRetainObject(object: newValue, for: KeyGradientLayer) }
    }
}


// MARK: MoeView

open class MoeView: View, ValuationViewProtocol, ValuationApplyProtocol {
    public convenience init(designator: Designator) {
        self.init(frame: .zero)
        designator.applyValuator(toView: self)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayout()
        updateShadowLayout()
    }
}


// MARK: MoeLabel

open class MoeLabel: UILabel, ValuationViewProtocol, ValuationApplyProtocol {
    func applyBackground(_ valuator: BackgroundValuator) {
        backgroundColor = .clear
        layer.backgroundColor = valuator.color.cgColor

        if let radius = valuator.cornerRadius {
            if valuator.isMaskCornerRadius == true {
                let maskColor = valuator.maskColor ?? superview?.backgroundColor
                layer.addCornerRadius(radius: radius,
                                      size: bounds.size,
                                      borderWidth: valuator.border?.width ?? 0.0,
                                      borderColor: valuator.border?.color ?? UIColor.black,
                                      maskColor: maskColor ?? .white)
            }
            else { layer.cornerRadius = radius }
        }
        if let border = valuator.border {
            layer.borderWidth = border.width!
            layer.borderColor = (border.color ?? UIColor.black).cgColor
        }
        if let _ = valuator.gradient {
            let clazzName = NSStringFromClass(self.classForCoder)
            MLog("注意：`\(clazzName)`类并不支持直接使用渐变图层。请将`Label`作为子视图添加至配置渐变背景的视图")
        }
    }
    
    func applyText(_ valuator: TextValuator) {
        guard valuator.state == .normal else {
            let clazzName = NSStringFromClass(self.classForCoder)
            MLog("注意：`\(clazzName)`类仅支持普通状态的文本赋值(`TextValuator`)")
            return
        }
        
        if let text = valuator.text { self.text = text }
        self.textColor = valuator.color
        self.font = valuator.font
        self.numberOfLines = valuator.numberOfLines
        
        if let alignment = valuator.alignment { self.textAlignment = alignment }
        if let indent = valuator.firstLineIndent, let title = valuator.text {
            var attrDict: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.foregroundColor : valuator.color,
                NSAttributedString.Key.font : valuator.font
            ]

            let style = NSMutableParagraphStyle()
            style.firstLineHeadIndent = indent * self.font.pointSize;
            style.lineSpacing = 5
            attrDict[NSAttributedString.Key.paragraphStyle] = style

            let attrText = NSAttributedString(string: title, attributes: attrDict)
            self.attributedText = attrText
        }
    }
    
    func applyShadow(_ valuator: ShadowValuator) {
        layer.shadowColor = valuator.color.cgColor
        layer.shadowOpacity = valuator.opacity ?? 1.0
        layer.shadowOffset = valuator.offset ?? CGSize(width: 0, height: 0)
        layer.masksToBounds = false
        updateShadowLayout()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowLayout()
    }
}


// MARK: MoeButton

open class MoeButton: UIButton, ValuationViewProtocol, ValuationApplyProtocol {
    func applyText(_ valuator: TextValuator) {
        let state = valuator.state
        switch state {
        case .normal:
            // .normal状态时，字体配置直接操作`titleLabel`来实现
            titleLabel?.font = valuator.font
            setTitleColor(valuator.color, for: state)
            if let title = valuator.text { setTitle(title, for: state) }
        default:
            // 非normal状态时，若text无指定值，尝试获取normal状态的text值
            var text = valuator.text
            if text == nil {
                let normalVtor = self.designator.find(valuatorType: TextValuator.self, coditionType: .state(.normal))
                text = normalVtor?.text
            }
            if text == nil { text = titleLabel?.text }
            if let title = text {
                // 非normal状态时，使用富文本来实现标题展示，由富文本控制字体
                let attrStr = NSAttributedString(string: title, attributes: [
                    NSAttributedString.Key.font : valuator.font,
                    NSAttributedString.Key.foregroundColor : valuator.color
                ])
                setAttributedTitle(attrStr, for: state)
            }
        }
    }
    
    func applyImage(_ valuator: ImageValuator) {
        let state = valuator.state
        let radius = valuator.cornerRadius ?? 0.0
        
        if let image = valuator.image?.withRenderingMode(.alwaysOriginal) {
            if radius <= 0.0 { setImage(image, for: state) }
            else { setImage(image.moe.radiusImage(radius: radius), for: state) }
        }
        if let image = valuator.backgroundImage {
            if radius <= 0.0 { setBackgroundImage(image, for: state) }
            else { setBackgroundImage(image.moe.radiusImage(radius: radius), for: state) }
        }
    }
    
    func applyEvent(_ valuator: EventValuator) {
        if let target = valuator.target, let action = valuator.action
        { self.addTarget(target, action: action, for: valuator.event) }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayout()
        updateShadowLayout()
    }
}


// MARK: ImageView

open class MoeImageView: UIImageView, ValuationViewProtocol, ValuationApplyProtocol {
    func applyImage(_ valuator: ImageValuator) {
        guard valuator.state == .normal else {
            let clazzName = NSStringFromClass(self.classForCoder)
            MLog("注意：`\(clazzName)`类仅支持普通状态的图片赋值(`TextValuator`)")
            return
        }
        let radius = valuator.cornerRadius ?? 0.0
        if let image = valuator.image {
            if radius > 0.0{
                // 通过裁切方式(`clipToBounds`)实现的圆角与阴影冲突，因此使用遮罩圆角处理
                let shadowValuator = designator.find(valuatorType: ShadowValuator.self,
                                                      coditionType: .none)
                if shadowValuator != nil {
                    self.image = image.moe.radiusImage(radius: radius, size: bounds.size)
                } else if valuator.isMaskCornerRadius == true {
                    self.image = image.moe.radiusImage(radius: radius, size: bounds.size)
                } else {
                    layer.masksToBounds = true
                    layer.cornerRadius = radius
                    self.image = image
                }
            }
            else { self.image = image }
        }
        if let _ = valuator.backgroundImage {
            let clazzName = NSStringFromClass(self.classForCoder)
            MLog("注意：`\(clazzName)`类并不支持背景图的图片赋值(ImageValuator)")
        }
    }
    
    func applyShadow(_ valuator: ShadowValuator) {
        layer.shadowColor = valuator.color.cgColor
        layer.shadowOpacity = valuator.opacity ?? 1.0
        layer.shadowOffset = valuator.offset ?? CGSize(width: 0, height: 0)
        layer.masksToBounds = false
        updateShadowLayout()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayout()
        updateShadowLayout()
    }
}
