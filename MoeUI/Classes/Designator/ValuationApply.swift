//
//  ValuatorApply.swift
//  MoeUIDemo
//
//  Created by Zed on 2019/11/25.
//  Copyright © 2019 www.moemone.com. All rights reserved.
//

import UIKit
import MoeCommon


// MARK: - 赋值器实现协议
protocol ValuationApplyProtocol where Self: ValuationViewProtocol {
    
    /// 将赋值器应用于视图上
    /// - Parameter valuatorType: 赋值器类型
    func applyValuation(valuatorType: ValuatorType)

    /// 应用常规赋值器，进行常规参数赋值
    func applyGeneral(_ valuator: GeneralValuator)
    /// 应用背景赋值器，进行背景参数赋值
    func applyBackground(_ valuator: BackgroundValuator)
    /// 应用阴影赋值器，进行阴影参数赋值
    func applyShadow(_ valuator: ShadowValuator)
    /// 应用文本赋值器，进行文本参数赋值
    func applyText(_ valuator: TextValuator)
    /// 应用图片赋值器，进行图片参数赋值
    func applyImage(_ valuator: ImageValuator)
    /// 应用事件赋值器，进行事件参数赋值
    func applyEvent(_ valuator: EventValuator)
    
    /// 更新阴影的布局。对于Autolayout约束的控件, 在布局子视图时需要更新
    func updateShadowLayout()
    
    /// 更新阴影的布局。对于Autolayout约束的控件, 在布局子视图时需要更新
    func updateGradientLayout()
}


// MARK: - 赋值器实现协议的默认实现扩展
/// 可赋值控件在实现了该协议后，取得各赋值器的默认实现效果
/// 控件可根据实际情况自行实现协议内相关方法
extension ValuationApplyProtocol {
    
    public func applyValuation(valuatorType: ValuatorType) {
        switch valuatorType {
        case .general(let valuator): applyGeneral(valuator)
        case .background(let valuator): applyBackground(valuator)
        case .shadow(let valuator): applyShadow(valuator)
        case .text(let valuator): applyText(valuator)
        case .image(let valuator): applyImage(valuator)
        case .event(let valuator): applyEvent(valuator)
        }
    }
    
    // MARK: 赋值器应用相关
    
    func applyGeneral(_ valuator: GeneralValuator) {
        if let frame = valuator.frame { self.frame = frame }
        if let alpha = valuator.alpha { self.alpha = alpha }
        if let enable = valuator.userInterfaceEnable
        { isUserInteractionEnabled = enable }
    }
    
    func applyBackground(_ valuator: BackgroundValuator) {
        backgroundColor = valuator.color
        
        if let radius = valuator.cornerRadius {
            if valuator.isMaskCornerRadius == true {
                let maskColor = valuator.maskColor ?? superview?.backgroundColor
                layer.addCornerRadius(radius: radius, maskColor: maskColor ?? .black)
            }
            else {
                layer.cornerRadius = radius
                layer.masksToBounds = true
            }
        }
        if let border = valuator.border {
            layer.borderWidth = border.width ?? 0.0
            layer.borderColor = (border.color ?? UIColor.black).cgColor
        }
        if let gradient = valuator.gradient {
            var cgColors: [CGColor] = []
            for color in gradient.colors { cgColors.append(color.cgColor) }
            
            gradientLayer.frame = layer.bounds
            gradientLayer.colors = cgColors
            gradientLayer.locations = gradient.locations
            gradientLayer.startPoint = gradient.startPoint
            gradientLayer.endPoint = gradient.endPoint
            if let radius = valuator.cornerRadius { gradientLayer.cornerRadius = radius }
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            if (gradientLayer.superlayer != nil) { gradientLayer.removeFromSuperlayer() }
        }
    }
    
    func applyShadow(_ valuator: ShadowValuator) {
        layer.shadowColor = valuator.color.cgColor
        layer.shadowOpacity = valuator.opacity ?? 1.0
        layer.shadowOffset = valuator.offset ?? CGSize(width: 0, height: 0)
        updateShadowLayout()
    }
    
    func applyText(_ valuator: TextValuator) {
        let clazzName = NSStringFromClass(self.classForCoder)
        MLog("注意：`\(clazzName)`类并不支持文本赋值(`TextValuator`)")
    }
    
    func applyImage(_ valuator: ImageValuator) {
        let clazzName = NSStringFromClass(self.classForCoder)
        MLog("注意：`\(clazzName)`类并不支持图片赋值(`ImageValuator`)")
    }
    
    func applyEvent(_ valuator: EventValuator) {
        let clazzName = NSStringFromClass(self.classForCoder)
        MLog("注意：`\(clazzName)`类并不支持事件赋值(`EventValuator`)")
    }
    
    // MARK: 布局更新相关
    
    func updateShadowLayout() {
        let backgroundValuator = designator.find(valuatorType: ShadowValuator.self,
                                                  coditionType: .none)
        guard let valuator = backgroundValuator else { return }
        
        let rect = bounds.insetBy(dx: -(valuator.extend?.width ?? 0.0),
                                  dy: -(valuator.extend?.height ?? 0.0))
        if let cornerRadius = valuator.cornerRadius, cornerRadius > 0.0 {
            layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        }
        else { layer.shadowPath = UIBezierPath(rect: rect).cgPath }
    }
    
    func updateGradientLayout() {
        let valuator = designator.find(valuatorType: BackgroundValuator.self,
                                        coditionType: .none)
        if let valuator = valuator, valuator.gradient != nil
        { gradientLayer.frame = layer.bounds }
    }
}
