//
//  UIConstants.swift
//  MoeUI
//
//  Created by Zed on 2019/7/23.
//
//  常量 - UI功能

import UIKit


public struct MScreen {
    public static let sacle = UIScreen.main.scale
    public static let bounds = UIScreen.main.bounds
    public static let size = UIScreen.main.bounds.size
    public static let width = UIScreen.main.bounds.size.width
    public static let height = UIScreen.main.bounds.size.height

    public static func navigationHeight() -> CGFloat {
        var navH: CGFloat = 64.0
        if #available(iOS 11.0, *), let mainWindow = UIApplication.shared.delegate?.window {
            if mainWindow != nil, mainWindow!.safeAreaInsets.bottom > 0.0 { navH = 84.0 }
        }
        return navH
    }
}
