//
//  ProjectConstants.swift
//  MoeUI
//
//  Created by Zed on 2019/7/23.
//
//  常量 - 项目通用

import UIKit


/// Debug message log
///
/// print debug message, include: `method name@file name`, `line number`, `log message`
public func MLog<T>(_ fmt: T, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let fileName = NSString(string: file).pathComponents.last!
    print("[MoeUI_Debug_Print: \(fileName) > \(function), \(line)]\n\t\(fmt)")
//    debugPrint(fmt)
    #endif
}


public func MKey(for name: String, file: String = #file) -> String {
    let fileName = NSString(string: file).pathComponents.last!
    return String(format: "[%@]: %@", fileName, name)
}


/// Device info & App info
public struct MInfo {
    /// 命名空间
    public static let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
    /// 应用版本号
    public static let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    /// 手机系统版本
    public static let phoneVersion = (UIDevice.current.systemVersion as NSString).doubleValue
    /// 手机型号
    public static let phoneModel = UIDevice.current.model
}
