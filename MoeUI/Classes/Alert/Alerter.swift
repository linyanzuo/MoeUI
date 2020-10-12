//
//  Alerter.swift
//  MoeUI
//
//  Created by Zed on 2019/9/8.
//
/**
 【提示】提示器
 */

import UIKit


/// 提示视图标识ID
public typealias AlertIdentifier = String


/// 提示器
open class Alerter: NSObject {
    /// 检查是否在主线程执行（UI操作必须在主线程完成）
    private class func checkThread() {
        assert(Thread.current.isMainThread == true, "【MoeUI.Alert】UI操作必须在主线程中执行")
    }
    
    /// 获取当前时间字符串（精确到毫秒），作为提示视图标识ID并返回
    /// - Returns: 提示视图标识ID
    public class func generateIdentifier() -> AlertIdentifier {
        let dateDesc = formatter.string(from: Date())
        return dateDesc
    }
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddHHmmssSSSSSS"
        return formatter
    }()
}


// MARK: - 【提示器】基于视图提示
extension Alerter {
    /// 将自定义视图覆盖于目标视图上；
    /// 该方法会给目标视图添加AlertView（遮罩层）作为子视图覆盖在目标视图上，而自定义视图将作为AlertView的子视图
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - view:       目标视图
    ///   - identifier: 提示视图绑定的标识，关闭提示视图时根据该标识进行匹配
    public class func show(_ customView: UIView, in view: UIView, with identifier: String, maskEnable: Bool = false) {
        checkThread()

        var optionalAlertView: AlertView? = nil
        // 1. 若父视图中已存在AlertView实例，则直接置顶使用
        for subview in view.subviews {
            if let subAlertView = subview as? AlertView {
                view.bringSubviewToFront(subAlertView)
                optionalAlertView = subAlertView
            }
        }
        // 2. 否则创建新的AlertView实例（AlertView透明覆盖于父视图之上，自定义视图作为AlertView的子视图展示）
        if optionalAlertView == nil {
            optionalAlertView = AlertView(frame: .zero)
            optionalAlertView?.maskEnable = maskEnable
            optionalAlertView?.maskTapHandler = {
                hide(in: view, with: identifier)
            }
            view.addSubview(optionalAlertView!)
            // AlertView的尺寸与目标视图相同；使用AutoLayout让AlertView与目标视图保持同步尺寸变化
            optionalAlertView!.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints([
                NSLayoutConstraint(item: optionalAlertView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: optionalAlertView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: optionalAlertView!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: optionalAlertView!, attribute: .right, relatedBy: .equal, toItem: view, attribute: . right, multiplier: 1.0, constant: 0.0)
            ])
        }
        optionalAlertView!.addAlert(customView: customView, with: identifier)
    }

    /// 关闭在某视图上执行的提示
    /// - Parameters:
    ///   - view:       执行了提示操作的视图
    ///   - identifier: 提示视图绑定的标识
    public class func hide(in view: UIView, with identifier: String) {
        checkThread()
        for subview in view.subviews {
            if let alertView = subview as? AlertView {
                alertView.removeAlert(with: identifier, completionHandler: nil)
            }
        }
    }
}


// MARK: - 【提示器】基于窗口提示
extension Alerter {
    /// 全局提示自定义视图
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - identifier: 提示视图绑定的标识
    public class func showGlobal(_ customView: UIView, with identifier: AlertIdentifier, maskEnable: Bool = false) {
        checkThread()
        AlertWindow.shared.maskEnable = maskEnable
        AlertWindow.shared.addAlert(customView: customView, with: identifier)
    }

    /// 隐藏指定标识关联的全局提示
    /// - Parameter identifier: 提示视图绑定的标识
    public class func hideGlobal(with identifier: AlertIdentifier) {
        checkThread()
        AlertWindow.shared.removeAlert(with: identifier)
    }
}
