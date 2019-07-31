//
//  String+MoeUI.swift
//  MoeUI
//
//  Created by Zed on 2019/7/23.
//
//  扩展 - 字符串处理

import Foundation

public extension String {
    /// 将NSRange转换成RangeExperssion
    ///
    /// - Parameter range: NSRange实例
    /// - Returns: Range<String.Index>实例
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }

    /// 获取固定位置的子字符串
    ///
    /// - Parameter start: 开始截取位置
    /// - Parameter length: 截取长度, 默认取到尾
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
}
