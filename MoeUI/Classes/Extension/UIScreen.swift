//
//  UIScreen+Moe.swift
//  MoeUI-MoeUI
//
//  Created by Zed on 2022/4/14.
//

import UIKit
import MoeCommon


// MARK: - UIApplication
public extension TypeWrapperProtocol where WrappedType: UIApplication {
    /// 获取当前置顶的窗口实例
    static var topWindow: UIWindow? { get { UIApplication.shared.windows.first } }
    
    /// 获取AppDelegate关联的窗口实例
    static var keyWindow: UIWindow? { get { UIApplication.shared.keyWindow } }
}


// MARK: - UIScreen
public extension TypeWrapperProtocol where WrappedType: UIScreen {
    /// 判断当屏幕是否刘海屏
    static var isBangs: Bool {
        get {
            if #available(iOS 11.0, *) {
                let mainWindow = UIApplication.shared.windows.first!
                return mainWindow.safeAreaInsets.bottom > 0
            }
            return false
        }
    }
    
    /// 获取当前设备的导航栏(包含状态栏的20像素)高度
    /// 刘海屏设备的顶部安全区域高度为20.0
    static var navigationHeight: CGFloat { get { return isBangs ? 84.0 : 64.0 } }
    
    /// 获取当前设备的选项栏高度
    /// 刘海屏设备的底部安全区域高度为34.0
    static var tabHeight: CGFloat { get { return isBangs ? 83.0 : 49.0 } }
}
