//
//  Created by Zed on 2020/8/18.
//  Copyright © 2020 www.moemone.com. All rights reserved.
//

import UIKit
import MoeCommon


/// 渐变颜色的绘制方向
public enum GradientType: Int {
    /// 从上到下绘制渐变色
    case TopToBottom = 0
    /// 从左到右绘制渐变色
    case LeftToRight = 1
    /// 左上到右下绘制渐变色
    case UpleftToLowright = 2
    /// 右上到左下绘制渐变色
    case UprightToLowleft = 3
}


// MARK: - UIImage 图片绘制相关扩展
public extension TypeWrapperProtocol where WrappedType: UIImage {
    // MARK: - 在指定尺寸的图形上下文环境中，执行闭包代码绘制图片
    /// 在指定尺寸的图形上下文环境中，执行闭包代码绘制图片
    /// - Parameters:
    ///   - size:           图形上下文尺寸，即生成图片的尺寸
    ///   - drawClosure:    绘制图片的闭包代码
    /// - Returns:          生成的图片
    static func drawImage(
        with size: CGSize,
        opaque: Bool,
        drawClosure: (CGContext) -> Void
    ) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        var image: UIImage? = nil
        if let context = UIGraphicsGetCurrentContext() {
            drawClosure(context)
            image = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
        return image
    }
    
    // MARK: - 生成纯背景色的图片
    /// 生成纯背景色的图片
    /// - Parameters:
    ///   - color:  图片背景色
    ///   - size:   图片尺寸
    /// - Returns:  生成的纯背景色图片
    static func image(with color: UIColor, size: CGSize) -> UIImage? {
        return drawImage(with: size, opaque: true) { (context) in
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        }
    }
    
    // MARK: - 生成渐变背景色的图片
    /// 生成渐变背景色的图片
    /// - Parameters:
    ///   - colors:     包含渐变颜色的数组
    ///   - locations:  颜色占比，值范围 0 ~ 1.0
    ///   - size:       图片导语
    ///   - type:       渐变颜色的绘制方向
    /// - Returns:      生成的渐变背景色图片
    static func gradientImage(
        colors: Array<UIColor>,
        locations: [CGFloat] = [0.0, 1.0],
        size: CGSize,
        type: GradientType = .LeftToRight
    ) -> UIImage? {
        let defaultAllocaor = CFAllocatorGetDefault().takeUnretainedValue()
        // CFArrayCreateMutable得到的是一个托管对象,所以不需要像OC一样使用CFRelease来释放它了
        let cgColors = CFArrayCreateMutable(defaultAllocaor, 0, nil)
        if (cgColors == nil) { return nil }
        for color in colors {
            CFArrayAppendValue(cgColors, Unmanaged.passRetained(color.cgColor).autorelease().toOpaque())
        }
        
        return drawImage(with: size, opaque: true) { (context) in
            context.saveGState()
            let colorSpace = colors.last?.cgColor.colorSpace
            guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors!, locations: locations)
                else { return }
            var start: CGPoint, end: CGPoint
            switch type {
            case .TopToBottom:
                start = CGPoint(x: 0.0, y: 0.0)
                end = CGPoint(x: 0.0, y: size.height)
            case .LeftToRight:
                start = CGPoint(x: 0.0, y: 0.0)
                end = CGPoint(x: size.width, y: 0.0)
            case .UpleftToLowright:
                start = CGPoint(x: 0.0, y: 0.0)
                end = CGPoint(x: size.width, y: size.height)
            case .UprightToLowleft:
                start = CGPoint(x: size.width, y: 0.0)
                end = CGPoint(x: 0.0, y: size.height)
            }
            context.drawLinearGradient(gradient, start: start, end: end, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
            context.restoreGState()
        }
    }
    
    // MARK: - 生成圆角图片，可指定尺寸、圆角、颜色、边框
    /// 生成圆角图片，可指定尺寸、圆角、颜色、边框
    /// - Parameters:
    ///   - radius:             圆角半径
    ///   - corner:             圆角位置，默认为全部4个角都处理
    ///   - size:               圆角图片的尺寸
    ///   - borderWidth:        图片边框的线宽。默认为0，即无边框
    ///   - borderColor:        图片边框的颜色。默认为黑色
    ///   - backgroundColor:    图片背景色
    /// - Returns:              生成的圆角图片
    static func roundedImage(
        radius: CGFloat,
        corner: UIRectCorner = .allCorners,
        size: CGSize,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = UIColor.black,
        backgroundColor: UIColor
    ) -> UIImage? {
        return drawImage(with: size, opaque: true) { (context) in
            let roundedRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let roundedPath = UIBezierPath(roundedRect: roundedRect,
                                           byRoundingCorners: corner,
                                           cornerRadii: CGSize(width: radius, height: radius))
            context.addPath(roundedPath.cgPath)

            context.setLineWidth(borderWidth)
            borderColor.setStroke()
            backgroundColor.setFill()
            context.drawPath(using: .fillStroke)
        }
    }
    
    // MARK: - 生成文本图片，可指定内容、尺寸、圆角、颜色、边框
    /// 生成文本图片，可指定内容、尺寸、圆角、颜色、边框
    /// - Parameters:
    ///   - size:               图片的尺寸
    ///   - text:               文本内容
    ///   - textAttributes:     文本属性
    ///   - radius:             圆角半径
    ///   - corner:             圆角位置，默认为全部4个角都处理
    ///   - borderWidth:        图片边框的线宽。默认为0，即无边框
    ///   - borderColor:        图片边框的颜色。默认为黑色
    ///   - backgroundColor:    图片背景色
    /// - Returns: 生成的文本图片
    static func textImage(
        size: CGSize,
        text: String,
        textAttributes: [NSAttributedString.Key : Any]? = nil,
        radius: CGFloat = 0,
        corner: UIRectCorner = .allCorners,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = UIColor.black,
        backgroundColor: UIColor
    ) -> UIImage? {
        return Self.drawImage(with: size, opaque: true) { (context) in
            let borderPath = UIBezierPath(
                roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                byRoundingCorners: corner,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            context.addPath(borderPath.cgPath)
            borderColor.setFill()
            context.drawPath(using: .fill)
            
            let halfBorder = borderWidth / 2
            let roundedPath = UIBezierPath(
                roundedRect: CGRect(x: halfBorder, y: halfBorder, width: size.width - borderWidth, height: size.height - borderWidth),
                byRoundingCorners: corner,
                cornerRadii: CGSize(width: radius - halfBorder, height: radius - halfBorder))
            context.addPath(roundedPath.cgPath)
            backgroundColor.setFill()
            context.drawPath(using: .fill)
            
            let textStr = NSString(string: text)
            let textSize = textStr.size(withAttributes: textAttributes)
            textStr.draw(
                in: CGRect(x: (size.width - textSize.width) / 2, y: (size.height - textSize.height) / 2, width: textSize.width, height: textSize.height),
                withAttributes: textAttributes
            )
        }
    }
    
    // MARK: - 生成混合渲染后的图片
    /// 生成混合渲染后的图片
    /// - Parameters:
    ///   - tintColor:  混合渲染的前景色
    ///   - blendMode:  混合模式
    ///   - alpha:      透明度
    /// - Returns:      混合渲染后的图片
    func renderImage(
        tintColor: UIColor,
        blendMode: CGBlendMode = .destinationIn,
        alpha: CGFloat = 1
    ) -> UIImage? {
        return Self.drawImage(with: wrappedValue.size, opaque: false) { (context) in
            tintColor.setFill()
            let bounds = CGRect.init(origin: CGPoint.zero, size: wrappedValue.size)
            UIRectFill(bounds)
            
            wrappedValue.draw(in: bounds, blendMode: blendMode, alpha: alpha)
            if blendMode != .destinationIn {
                wrappedValue.draw(in: bounds, blendMode: blendMode, alpha: alpha)
            }
        }
    }
}

