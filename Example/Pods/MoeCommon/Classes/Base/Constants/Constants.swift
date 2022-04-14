//
//  UIConstants.swift
//  MoeCommon
//
//  Created by Zed on 2019/11/19.
//

import UIKit


// MARK: Debug
/// 调试输出
/// - Parameter fmt:        输出的内容
/// - Parameter file:        调试代码所在的文件名
/// - Parameter line:       调试代码在文件中的行号
public func MLog<T>(_ fmt: T, file: String = #file, line: Int = #line) {
    #if DEBUG
    let fileName = NSString(string: file).pathComponents.last ?? "UnknowFileName"
    print("[\(fileName):\(line)]：\t\(fmt)")
    #endif
}

