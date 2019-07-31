//
//  UI+CornerRadius.swift
//  MoeUI
//
//  Created by Zed on 2019/7/23.
//
//  扩展 - 针对圆角

import UIKit

public extension UIImage {
    /// 生成指定尺寸的圆角图片
    ///
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - size: 图片尺寸
    /// - Returns: 生成的圆角图片
    func image(radius: CGFloat, corner: UIRectCorner = .allCorners, size: CGSize) -> UIImage? {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        let roundingPath = UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: corner,
                                        cornerRadii: CGSize(width: radius, height: radius))
        context.addPath(roundingPath.cgPath)
        context.clip()

        self.draw(in: rect)
        context.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return output
    }

    /// 返回处理后的圆角图片
    ///
    /// - Parameters:
    ///   - radius: 圆角半径
    /// - Returns: 生成的圆角图片
    func image(radius: CGFloat, corner: UIRectCorner = .allCorners) -> UIImage? {
        return image(radius: radius, corner: corner, size: self.size)
    }

    /// 绘制带框的圆角图片并返回
    ///
    /// - Parameters:
    ///   - radius: 圆角半径值
    ///   - corner: 圆角位置, 默认为4个圆角
    ///   - borderWidth: 边框的线粗, 默认为无边框
    ///   - borderColor: 边框的颜色, 默认为黑色
    ///   - backgroundColor: 图片背景色
    /// - Returns: 带框的圆角图片实例
    class func roundedRectImage(radius: CGFloat,
                                corner: UIRectCorner = .allCorners,
                                size: CGSize,
                                borderWidth: CGFloat = 0,
                                borderColor: UIColor = UIColor.black,
                                backgroundColor: UIColor) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        let roundedRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let roundedPath = UIBezierPath(roundedRect: roundedRect,
                                       byRoundingCorners: corner,
                                       cornerRadii: CGSize(width: radius, height: radius))
        context.addPath(roundedPath.cgPath)

        context.setLineWidth(borderWidth)
        borderColor.setStroke()
        backgroundColor.setFill()
        context.drawPath(using: .fillStroke)

        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return output
    }
}

public extension UIImageView {
    /// 对`UIImageView`的图片进行处理实现圆角效果. 此方法不会对溢出的子视图作处理
    ///
    /// - Parameters:
    ///   - radius: 圆角半径
    func addCornerRadius(_ radius: CGFloat) {
        self.image = self.image?.image(radius: radius, corner: .allCorners, size: self.bounds.size)
    }
}


