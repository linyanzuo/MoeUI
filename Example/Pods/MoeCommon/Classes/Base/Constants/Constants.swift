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
/// - Parameter file:       调试代码所在的文件名
/// - Parameter function:   调试代码所处的方法名
/// - Parameter line:       调试代码在文件中的行号
public func MLog<T>(_ fmt: T, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let fileName = NSString(string: file).pathComponents.last ?? "UnknowFileName"
    print("[Moe_Debug_Print: \(fileName) > \(function), \(line)]\n\t\(fmt)")
    #endif
    /// Todo: 日志记录
}


// MARK: Screen
/// 屏幕信息
public struct MScreen {
    /// 获取当前设备的屏幕像素比例系数
    public static let sacle = UIScreen.main.scale
    /// 获取当前设备的边框
    public static let bounds = UIScreen.main.bounds
    /// 获取当前设备的屏幕尺寸
    public static let size = UIScreen.main.bounds.size
    /// 获取当前设备的屏幕宽度
    public static let width = UIScreen.main.bounds.size.width
    /// 获取当前设备的屏幕高度
    public static let height = UIScreen.main.bounds.size.height
    
    /// 判断当屏幕是否刘海屏
    public static var isBangs: Bool {
        get {
            if #available(iOS 11.0, *), let mainWindow = UIApplication.shared.windows.first {
                return mainWindow.safeAreaInsets.bottom > 0
            }
            return false
        }
    }
    
    /// 获取当前设备的导航栏(包含状态栏的20像素)高度
    /// 刘海屏设备的顶部安全区域高度为20.0
    public static var navigationHeight: CGFloat {
        get { return isBangs ? 84.0 : 64.0 }
    }
    
    /// 获取当前设备的选项栏高度
    /// 刘海屏设备的底部安全区域高度为34.0
    public static var tabHeight: CGFloat {
        get { return isBangs ? 83.0 : 49.0 }
    }
}


// MARK: Window
/// 窗口信息
public struct MWindow {
    /// 获取当前置顶的窗口实例
    public static let top = UIApplication.shared.windows.first
    /// 获取AppDelegate关联的窗口实例
    public static let key = UIApplication.shared.keyWindow
}


// MARK: Project
/// 项目信息
public struct MInfo {
    /// 命名空间
    public static let namespace = info(for: "CFBundleExecutable") ?? "获取【命名空间】失败"
    /// 应用版本号
    public static let appVersion = info(for: "CFBundleShortVersionString") ?? "获取【应用版本号】失败"
    /// 应用BundleID
    public static let bundleID = info(for: "CFBundleIdentifier") ?? "获取【应用BundleID】失败"
    
    private static func info(for key: String) -> String? {
        guard let infoDict = Bundle.main.infoDictionary else { return nil }
        guard let result = infoDict[key] as? String else { return nil }
        return result
    }
}


// MARK: Device

/// 设备信息
public struct MDevice {
    /// 手机型号
    public static let phoneModel = UIDevice.current.model
    /// 手机系统版本
    public static let phoneVersion = (UIDevice.current.systemVersion as NSString).doubleValue
}
