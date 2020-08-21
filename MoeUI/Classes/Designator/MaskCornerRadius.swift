//
//  CornerRadius.swift
//  MoeUIDemo
//
//  Created by Zed on 2019/11/28.
//  Copyright © 2019 www.moemone.com. All rights reserved.
//

/// “圆角遮罩处理”： 在原图上添加一层“圆角遮罩图层”，遮罩图层上绘制了“圆角遮罩图片”。其中
///    * “圆角遮罩图片”的内容部分为透明，不会挡住原图内容
///    * “圆角遮罩图片”的圆角部分为指定颜色(与背景色一样)
/// 将“圆角遮罩图层”挡在原图之上, 由于圆角颜色与背景色一样，形成被裁切成圆角的视觉误差
///
/// 使用“圆角遮罩处理”可避免iOS10之前版本的圆角处理所引发的离屏渲染问题
/// “圆角遮罩处理”并非对图片进行裁切，使用时需把握好背景色的配置

import UIKit
import MoeCommon


// MARK: 图片的“圆角遮罩处理”

public extension TypeWrapperProtocol where WrappedType: UIImage {
    
    // MARK: 图片的圆角遮罩处理
    
    /// 返回“圆角遮罩处理”后的圆角图片
    /// - Parameter radius: 圆角半径
    /// - Parameter corner: 圆角位置，默认为全部4个角都处理
    func radiusImage(radius: CGFloat, corner: UIRectCorner = .allCorners) -> UIImage? {
        return radiusImage(radius: radius, corner: corner, size: wrappedValue.size)
    }
    
    /// 返回固定尺寸的“圆角遮罩处理”后的圆角图片
    /// - Parameter radius: 圆角半径
    /// - Parameter corner: 圆角位置，默认为全部4个角都处理
    /// - Parameter size: 圆角图片的尺寸
    func radiusImage(
        radius: CGFloat,
        corner: UIRectCorner = .allCorners,
        size: CGSize
    ) -> UIImage? {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        return UIImage.moe.drawImage(with: rect.size, opaque: false) { (context) in
            let roundingPath = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corner,
                cornerRadii: CGSize(width: radius, height: radius))
            context.addPath(roundingPath.cgPath)
            context.clip()
            
            wrappedValue.draw(in: rect)
            context.drawPath(using: .fillStroke)
        }
    }
    
    /// 根据配置参数绘制“圆角遮罩图片”并返回
    /// - Parameter radius: 圆角半径
    /// - Parameter corner: 圆角位置，默认为全部4个角都处理
    /// - Parameter size: 圆角图片的尺寸
    /// - Parameter maskColor: 圆角遮罩图片的圆角颜色，通常为图片展示视图的父视图背景色
    /// - Parameter borderWidth: 图片边框的线宽。默认为0，即无边框
    /// - Parameter borderColor: 图片边框的颜色。默认为黑色
    static func roundedMaskImage(
        radius: CGFloat,
        corner: UIRectCorner = .allCorners,
        size: CGSize,
        maskColor: UIColor,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = UIColor.black
    ) -> UIImage? {
        return drawImage(with: size, opaque: false) { (context) in
            maskColor.setFill()
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let rectPath = UIBezierPath(rect: rect)
            let roundedPath = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corner,
                cornerRadii: CGSize(width: radius, height: radius))
            rectPath.append(roundedPath)
            context.addPath(rectPath.cgPath)
            context.drawPath(using: .eoFill)

            guard borderWidth > 0 else { return }
            let borderOutterPath = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corner,
                cornerRadii: CGSize(width: radius, height: radius))
            let borderInnerPath = UIBezierPath(
                roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth),
                byRoundingCorners: corner,
                cornerRadii: CGSize(width: radius, height: radius))
            borderOutterPath.append(borderInnerPath)
            context.addPath(borderOutterPath.cgPath)
            borderColor.setFill()
            context.drawPath(using: .eoFill)
        }
    }
}


// MARK: “圆角遮罩处理”的辅助类

/// 圆角遮罩图片缓存池
fileprivate var maskImageCache: Set<MaskImage> = Set()

/// 圆角遮罩图片
class MaskImage: NSObject {
    var image: UIImage?
    var attribute: Attribute

    init(image: UIImage?, attribute: Attribute) {
        self.image = image
        self.attribute = attribute
    }
    
    /// 图片属性
    public struct Attribute: Equatable {
        var size: CGSize
        var color: UIColor
        var radius: CGFloat
        var corner: UIRectCorner
        var borderWidth: CGFloat
        var borderColor: UIColor
    }
}


// MARK: 图层的“圆角遮罩处理”

extension CALayer: Runtime {
    
    var KeyMaskLayer: Key { get { return runtimeKey(for: "CornerRadiusMaskLayer")! } }
    var KeyMaskImage: Key { get { return runtimeKey(for: "CornerRadiusMaskImage")! } }
    
    // MARK: 动态添加的属性
    
    /// 圆角遮罩图层
    @objc var cornerRadiusMaskLayer: CALayer {
        get {
            var _maskLayer = getAssociatedObject(for: KeyMaskLayer) as? CALayer
            if _maskLayer == nil {
                _maskLayer = CALayer()
                setAssociatedRetainObject(object: _maskLayer, for: KeyMaskLayer)
            }
            return _maskLayer!
        }
        set { setAssociatedRetainObject(object: newValue, for: KeyMaskLayer) }
    }
    
    /// 圆角遮罩图片
    @objc var maskImage: MaskImage? {
        get { return getAssociatedObject(for: KeyMaskImage) as? MaskImage }
        set { setAssociatedRetainObject(object: newValue, for: KeyMaskImage) }
    }
    
    /// 尝试从缓存池中获取圆角遮罩图片并返回。
    /// 如果失败则创建新的圆角遮罩图片，将其缓存至缓存池并返回
    /// - Parameter attribute: 圆角遮罩图片的属性
    func getMaskImageFromCache(with attribute: MaskImage.Attribute) -> UIImage? {
        for maskImage in maskImageCache {
            if maskImage.attribute == attribute { return maskImage.image }
        }

        guard attribute.size.width > 0, attribute.size.height > 0 else { return nil }
        let image = UIImage.moe.roundedMaskImage(radius: attribute.radius,
                                                 size: attribute.size,
                                                 maskColor: attribute.color)
        let maskImage = MaskImage(image: image, attribute: attribute)
        maskImageCache.insert(maskImage)
        return image
    }
    
    /// 添加带边框的“圆角遮罩图层”，使当前图层形成圆角裁切的效果。溢出的子图层部分也会被遮挡
    /// - Parameter radius: 圆角半径
    /// - Parameter corner: 圆角位置，默认为全部4个角都处理
    /// - Parameter size: 圆角图片的尺寸
    /// - Parameter borderWidth: 图片边框的线宽。默认为0，即无边框
    /// - Parameter borderColor: 图片边框的颜色。默认为黑色
    /// - Parameter maskColor: 圆角遮罩图片的圆角颜色，通常为图片展示视图的父视图背景色，默认为白色
    public func addCornerRadius(
        radius: CGFloat,
        corner: UIRectCorner = .allCorners,
        size: CGSize = .zero,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = .black,
        maskColor: UIColor = .white
    ) {
        let maskImageAttribute = MaskImage.Attribute(
            size: self.bounds.size,
            color: maskColor,
            radius: radius,
            corner: corner,
            borderWidth: borderWidth,
            borderColor: borderColor)
        self.maskImage = MaskImage(image: nil, attribute: maskImageAttribute)
        updateMaskLayerLayout()
    }
    
    /// 更新遮罩图片的布局。对于Autolayout约束的控件, 在布局子视图时需要更新遮罩的尺寸。
    /// 为避免对CALayer类造成不必要影响，不使用运行时进行方法交换。请手动调用本方法
    public func updateMaskLayerLayout() {
        guard var attribute = self.maskImage?.attribute else { return }
        attribute.size = self.bounds.size
        let image = getMaskImageFromCache(with: attribute)

        if image != self.maskImage?.image {
            self.maskImage?.image = image
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            cornerRadiusMaskLayer.contents = image?.cgImage
            cornerRadiusMaskLayer.frame = self.bounds
            CATransaction.commit()
        }

        if cornerRadiusMaskLayer.superlayer == nil { addSublayer(cornerRadiusMaskLayer) }
    }
}
