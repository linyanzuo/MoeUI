//
//  UIConstants.swift
//  MoeCommon
//
//  Created by Zed on 2019/11/19.
//

// MARK: Debug

/// 调试输出
/// - Parameter fmt: 输出的内容
/// - Parameter file: 调试代码所在的文件名
/// - Parameter function: 调试代码所处的方法名
/// - Parameter line: 调试代码在文件中的行号
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

    /// 获取当前导航栏(包含状态栏的20像素)的高度
    public static func navigationHeight() -> CGFloat {
        var navH: CGFloat = 64.0
        if #available(iOS 11.0, *), let mainWindow = UIApplication.shared.delegate?.window {
            if mainWindow != nil, mainWindow!.safeAreaInsets.bottom > 0.0 { navH = 84.0 }
        }
        return navH
    }
}


// MARK: Project

/// 项目信息
public struct MInfo {
    /// 命名空间
    public static let namespace = info(for: "CFBundleExecutable")
    /// 应用版本号
    public static let appVersion = info(for: "CFBundleShortVersionString")
    
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
