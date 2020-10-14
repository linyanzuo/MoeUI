//
//  HUD.swift
//  MoeCommon
//
//  Created by Zed on 2020/8/21.
//
/**
 【提示】快速全局提示
 */

import UIKit


/// 快速全局提示器
open class HUD {
    
    private static var idStack: Array = Array<AlertIdentifier>()
    
    /// 展示指定内容及样式的提示框，并在持续一定时间后自动消失
    /// - Parameters:
    ///   - style:      指定样式
    ///   - text:       指定内容
    ///   - maskEnable: 是否启用遮罩，默认为不启用
    ///   - continued:  持续一段时间后自动消失，为0时需要手动关闭
    public class func show(style: AlertDialog.Style, text: String, maskEnable: Bool = false, continued: TimeInterval = 3.0) {
        let dialog = AlertDialog(style: style, text: text)
        if continued == 0.0 {
            let _ = show(customView: dialog, with: nil, maskEnable: true)
        } else {
            show(customView: dialog, maskEnable: maskEnable, continued: continued)
        }
    }
    
    /// 展示自定义视图，并在持续一定时间后自动消失
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - continued:  持续时间
    public class func show(customView: UIView, maskEnable: Bool = false, continued: TimeInterval) {
        let id = Alerter.generateIdentifier()
        Alerter.showGlobal(customView, with: id, maskEnable: maskEnable)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + continued, execute: {
            Alerter.hideGlobal(with: id)
        })
    }
    
    /// 展示自定义视图，并返回关联标识（关闭时使用）
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - alertId:    与视图关联的标识，不传值时则自动生成
    /// - Returns:      关联标识
    public class func show(customView: UIView, with alertId: AlertIdentifier? = nil, maskEnable: Bool = false) -> AlertIdentifier {
        var id = alertId
        if id == nil { id = Alerter.generateIdentifier() }
        Alerter.showGlobal(customView, with: id!, maskEnable: maskEnable)
        idStack.append(id!)
        return id!
    }
    
    /// 隐藏关联标识关联的自定义视图
    /// - Parameter alertId: 关联标识
    public class func hide(with alertId: AlertIdentifier? = nil) {
        guard let id = alertId ?? idStack.popLast() else { return }
        Alerter.hideGlobal(with: id)
    }
}
