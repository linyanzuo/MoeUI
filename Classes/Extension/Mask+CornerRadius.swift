//
//  Mask+CornerRadius.swift
//  MoeUI
//
//  Created by Zed on 2019/7/26.
//
//  扩展 - 圆角遮罩

import UIKit

fileprivate var maskImageCache: Set<CALayer.MaskImage> = Set()


public extension UIImage {
    class func roundedMaskIamge(radius: CGFloat,
                                corner: UIRectCorner = .allCorners,
                                size: CGSize,
                                maskColor: UIColor,
                                borderWidth: CGFloat = 0,
                                borderColor: UIColor = UIColor.black) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        maskColor.setFill()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let rectPath = UIBezierPath(rect: rect)
        let roundedPath = UIBezierPath(roundedRect: rect,
                                       byRoundingCorners: corner,
                                       cornerRadii: CGSize(width: radius, height: radius))
        rectPath.append(roundedPath)
        context.addPath(rectPath.cgPath)
        context.drawPath(using: .eoFill)

        if borderWidth > 0 {
            let borderOutterPath = UIBezierPath(roundedRect: rect,
                                                byRoundingCorners: corner,
                                                cornerRadii: CGSize(width: radius, height: radius))
            let borderInnerPath = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth),
                                          byRoundingCorners: corner,
                                          cornerRadii: CGSize(width: radius, height: radius))
            borderOutterPath.append(borderInnerPath)
            context.addPath(borderOutterPath.cgPath)
            borderColor.setFill()
            context.drawPath(using: .eoFill
            )
        }

        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return output
    }
}


extension CALayer {
    // MARK: Private Data Type
    class MaskImage: NSObject {
        var image: UIImage?
        var attribute: Attribute

        init(image: UIImage?, attribute: Attribute) {
            self.image = image
            self.attribute = attribute
        }

        public struct Attribute: Equatable {
            var size: CGSize
            var color: UIColor
            var radius: CGFloat
            var corner: UIRectCorner
            var borderWidth: CGFloat
            var borderColor: UIColor
        }
    }

    struct RuntimeKey {
        static let cornerRadiusMaskLayer = MRuntimeKey(for: "cornerRadiusMaskLayer")!
        static let maskImage = MRuntimeKey(for: "maskImage")!
        static let maskImageAttribute = MRuntimeKey(for: "maskImageAttribute")!
    }

    // MARK: Runtime Property
    /// 圆角遮罩图层
    @objc var cornerRadiusMaskLayer: CALayer {
        get {
            var _cornerRadiusMaskLayer = objc_getAssociatedObject(self, RuntimeKey.cornerRadiusMaskLayer) as? CALayer
            if _cornerRadiusMaskLayer == nil {
                _cornerRadiusMaskLayer = CALayer()
                _cornerRadiusMaskLayer!.isOpaque = true
                objc_setAssociatedObject(self, RuntimeKey.cornerRadiusMaskLayer, _cornerRadiusMaskLayer!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return _cornerRadiusMaskLayer!
        }
        set { objc_setAssociatedObject(self, RuntimeKey.cornerRadiusMaskLayer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// 圆角遮罩图
    @objc var maskImage: MaskImage? {
        get { return objc_getAssociatedObject(self, RuntimeKey.maskImage) as? MaskImage }
        set { objc_setAssociatedObject(self, RuntimeKey.maskImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    // MARK: Public Method
    /// 添加遮罩, 实现圆角效果. 溢出的子视图部分也会被遮挡成圆角
    ///
    /// 遮罩圆角的实现原理是: 添加一层遮罩图层, 图层里展示内容的部分为透明(圆形内容), 圆角部分为指定颜色(与背景的颜色一致), 借助与背景色一致的圆角图案, 形成被裁切成圆角的视觉误差
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - maskColor: 遮罩颜色, 不填写则默认为白色.
    public func addCornerRadius(_ radius: CGFloat, corner: UIRectCorner = .allCorners, maskColor: UIColor) {
        addCornerRadius(radius: radius, size: .zero, maskColor: maskColor)
    }

    /// 添加遮罩, 实现圆角效果. 溢出的子视图部分也会被遮挡成圆角
    ///
    /// 遮罩圆角的实现原理是: 添加一层遮罩图层, 图层里展示内容的部分为透明(圆形内容), 圆角部分为指定颜色(与背景的颜色一致), 借助与背景色一致的圆角图案, 形成被裁切成圆角的视觉误差
    /// - Parameters:
    ///   - radius: 圆角半径值
    ///   - corner: 圆角位置, 如左上方, 可自由组合, 默认为所有位置的圆角
    ///   - size: 遮罩图层的尺寸
    ///   - borderWidth: 边框的粗细, 默认为0, 即无边框
    ///   - borderColor: 边框的颜色, 默认为黑色
    ///   - maskColor: 遮罩颜色, 不填写则默认为白色.
    public func addCornerRadius(radius: CGFloat,
                                corner: UIRectCorner = .allCorners,
                                size: CGSize = .zero,
                                borderWidth: CGFloat = 0,
                                borderColor: UIColor = .black,
                                maskColor: UIColor = .white)
    {
        let maskImageAttribute = MaskImage.Attribute(size: self.bounds.size, color: maskColor, radius: radius, corner: corner, borderWidth: borderWidth, borderColor: borderColor)
        self.maskImage = MaskImage(image: nil, attribute: maskImageAttribute)
    }

    /// 对于Autolayout约束的控件, 在布局子视图时需要更新遮罩的尺寸, 因此需要swizzle成自定义的layoutSubviews
    public class func swizzleLayoutSubviews() {
        let originalMethod = class_getInstanceMethod(self.classForCoder(), #selector(CALayer.layoutSublayers))
        let targetMethod = class_getInstanceMethod(self.classForCoder(), #selector(m_layoutSubviews))
        guard originalMethod != nil, targetMethod != nil else { return }
        method_exchangeImplementations(originalMethod!, targetMethod!)
    }

    // MARK: Private Method
    /// 尝试从缓存中获取遮罩图片, 如果缓存中不存在, 则创建新的遮罩图片
    func getMaskImageFromCache(with attribute: MaskImage.Attribute) -> UIImage? {
        for maskImage in maskImageCache {
            if maskImage.attribute == attribute {
                return maskImage.image
            }
        }

        guard attribute.size != CGSize.zero else { return nil }
        let image = UIImage.roundedMaskIamge(radius: attribute.radius,
                                             corner: attribute.corner,
                                             size: attribute.size,
                                             maskColor: attribute.color,
                                             borderWidth: attribute.borderWidth,
                                             borderColor: attribute.borderColor)
        let maskImage = MaskImage(image: image, attribute: attribute)
        maskImageCache.insert(maskImage)
        return image
    }

    /// 布局子视图时, 处理圆角遮罩图层
    @objc func m_layoutSubviews() {
        self.m_layoutSubviews()

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

        if cornerRadiusMaskLayer.superlayer == nil {
            self.addSublayer(cornerRadiusMaskLayer)
        }
    }
}
