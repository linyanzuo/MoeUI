//
//  String+Moe.swift
//  MoeCommon
//
//  Created by Zed on 2020/9/10.
//
/**
 【字符串】相关扩展
 */

import UIKit


// MARK: - String

extension TypeWrapperProtocol where WrappedType == String {
    /// 获取指定位置的子字符串并返回
    /// - Parameter start: 开始截取位置(包含该位置的值)
    /// - Parameter length: 截取长度, 不指定则取到结束
    public func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = wrappedValue.count - start
        }
        let st = wrappedValue.index(wrappedValue.startIndex, offsetBy:start)
        let en = wrappedValue.index(st, offsetBy:len)
        return String(wrappedValue[st ..< en])
    }
    
    /// 计算文本内容在有限空间内，展示时所占据的尺寸
    /// - Parameters:
    ///   - limitSize:  有限空间的尺寸
    ///   - font:       文本字体
    /// - Returns:      文本内容占据的尺寸
    public func boundingSize(limitSize: CGSize, font: UIFont) -> CGSize {
        return NSString(string: self.wrappedValue).boundingRect(
            with: limitSize,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        ).size
    }
}

// MARK: - AttributedString

extension NSAttributedString {
    /// 根据指定参数，创建富文本实例
    /// - Parameters:
    ///   - text:   富文本内容
    ///   - size:   字体大小
    ///   - weight: 字体粗细，默认为普通
    ///   - color:  字体颜色
    ///   - lineSpacing: 行间距
    @available(iOS 8.2, *)
    convenience init(text: String, withFont size: CGFloat, weight: UIFont.Weight = .regular, color: UIColor = .black, lineSpacing: CGFloat? = nil) {
        var attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: size, weight: weight),
            NSAttributedString.Key.foregroundColor: color,
        ]
        if let lineSpacing = lineSpacing {
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = lineSpacing
            attributes[NSAttributedString.Key.paragraphStyle] = paraStyle
        }
        self.init(string: text, attributes: attributes)
    }
}
