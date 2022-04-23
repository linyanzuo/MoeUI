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
extension String: NamespaceWrappable {}
public extension TypeWrapperProtocol where WrappedType == String {
    /// 获取指定索引值所包含的区间值
    /// - Parameters:
    ///   - start:  开始索引值，包含开始索引
    ///   - end:    结束索引值，不包含结束索引
    /// - Returns:  从开始索引至结束索引的范围值
    func range(from start: Int, to end: Int) -> Range<String.Index>? {
        guard start <= end, end < wrappedValue.count else { return nil }
        let startIndex = wrappedValue.index(wrappedValue.startIndex, offsetBy: start)
        let endIndex = wrappedValue.index(wrappedValue.startIndex, offsetBy: end)
        return startIndex..<endIndex
    }
    
    /// 获取指定位置的子字符串并返回
    /// - Parameter start: 开始截取位置(包含该位置的值)
    /// - Parameter length: 截取长度, 不指定则取到结束
    func subString(start:Int, length:Int = -1) -> String? {
        guard start + length <= wrappedValue.count else { return nil }
        var len = length
        if len == -1 { len = wrappedValue.count - start }
        let st = wrappedValue.index(wrappedValue.startIndex, offsetBy:start)
        let en = wrappedValue.index(st, offsetBy:len)
        return String(wrappedValue[st ..< en])
    }
    
    /// 替换指定范围的内容为`*`号，并适当添加空格
    /// - Parameters:
    ///   - left:   起始位置保留的原字符个数
    ///   - right:  结束位置保留的原字符个数
    ///   - per:    每间隔多少个字符添加空格
    /// - Returns:  返回替换的字符
    func replaceAsterisk(leftKeep left: Int, rightKeep right: Int, insertWhitespace per: Int? = nil) -> String? {
        guard wrappedValue.count > left + right else { return nil }
        var asterisks = ""
        for i in left..<(wrappedValue.count - right) {
            if per != nil && i % per! == 0 { asterisks += " " }
            asterisks += "*"
        }
        if per != nil { asterisks += " " }
        let rightIndex = wrappedValue.count - right
        guard let rangeExp = wrappedValue.moe.range(from: left, to: rightIndex) else { return nil }
        return wrappedValue.replacingCharacters(in: rangeExp, with: asterisks)
    }
    
    /// 计算文本内容在有限空间内，展示时所占据的尺寸
    /// - Parameters:
    ///   - limitSize:  有限空间的尺寸
    ///   - font:       文本字体
    /// - Returns:      文本内容占据的尺寸
    func boundingSize(limitSize: CGSize, font: UIFont) -> CGSize {
        return NSString(string: self.wrappedValue).boundingRect(
            with: limitSize,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        ).size
    }
    
    /// Range转换为NSRange
    /// - Parameter range:  待转换的Range值
    /// - Returns:          转换后的NSRange值
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.wrappedValue.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
    
    /// NSRange转换为Range
    /// - Parameter nsRange:    待转换的NSRange值
    /// - Returns:              转换后的Range值
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = wrappedValue.utf16.index(wrappedValue.utf16.startIndex, offsetBy: nsRange.location,
                                                  limitedBy: wrappedValue.utf16.endIndex),
            let to16 = wrappedValue.utf16.index(from16, offsetBy: nsRange.length,
                                                limitedBy: wrappedValue.utf16.endIndex),
            let from = String.Index(from16, within: self.wrappedValue),
            let to = String.Index(to16, within: self.wrappedValue)
            else { return nil }
        return from ..< to
    }
    
    /// 将JSON字符串转换为字典，注意字符串本身应该有效的JSON内容才能顺利转换成功
    /// - Returns: JSON字符串对应的字典
    func jsonDictionary() -> [String: Any]? {
        guard let data = wrappedValue.data(using: .utf8) else { return nil }
        if let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            return dict as? [String: Any]
        }
        return nil
    }
}


// MARK: - AttributedString
public extension NSAttributedString {
    /// 根据指定参数，创建富文本实例
    /// - Parameters:
    ///   - text:           富文本内容
    ///   - size:           字体大小
    ///   - weight:         字体粗细，默认为普通
    ///   - color:          字体颜色
    ///   - lineSpacing:    行间距
    ///   - alignment:      对齐方式
    @available(iOS 9.0, *)
    convenience init(
        text: String,
        withFont size: CGFloat,
        weight: UIFont.Weight = .regular,
        color: UIColor = .black,
        lineSpacing: CGFloat? = nil,
        alignment: NSTextAlignment? = nil
    ) {
        var attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: size, weight: weight),
            NSAttributedString.Key.foregroundColor: color,
        ]
        if lineSpacing != nil || alignment != nil {
            let paraStyle = NSMutableParagraphStyle()
            if let ls = lineSpacing { paraStyle.lineSpacing = ls }
            if let al = alignment { paraStyle.alignment = al }
            attributes[NSAttributedString.Key.paragraphStyle] = paraStyle
        }
        self.init(string: text, attributes: attributes)
    }
    
    /// 创建图片内容的富文本实例
    /// - Parameters:
    ///   - image:      图片
    ///   - height:     图片高度
    ///   - offsetY:    竖直方向偏移量
    convenience init(image: UIImage, height: CGFloat, offsetY: CGFloat = 0) {
        let attach = NSTextAttachment()
        attach.image = image
        attach.bounds = CGRect(x: 0, y: offsetY, width:height / image.size.height * image.size.width, height: height)
        self.init(attachment: attach)
    }
}
