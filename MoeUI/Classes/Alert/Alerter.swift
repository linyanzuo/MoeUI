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
    
    /// 获取当前时间字符串（精确到毫秒），作为提示视图标识ID并返回
    /// - Returns: 提示视图标识ID
    public class func generateIdentifier() -> AlertIdentifier {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddHHmmssSSSSSS"
        let dateDesc = formatter.string(from: Date())
        return dateDesc
    }
    
    /// 检查是否在主线程执行提示操作
    private class func checkThread() {
        assert(Thread.current.isMainThread == true, "【MoeUI.Alert】UI操作必须在主线程中执行")
    }
    
}


// MARK: - 【提示器】基于视图提示

extension Alerter {
    
    /// 将自定义视图作为某视图的子视图，进行提示操作
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - view:       依赖视图，自定义视图作为它的子视图展示
    ///   - identifier: 提示视图绑定的标识，关闭提示时使用
    public class func show(_ customView: UIView, in view: UIView, with identifier: String) {
        checkThread()

        var alertView: AlertView? = nil
        // 若父视图中已存在AlertView实例则直接使用，否则创建新的AlertView实例
        for subview in view.subviews {
            if subview.isMember(of: AlertView.classForCoder()) { alertView = subview as? AlertView }
        }
        if alertView == nil {
            alertView = AlertView(frame: .zero)
            alertView?.maskTapHandler = {
                self.hide(in: view, with: identifier)
            }
            view.addSubview(alertView!)

            alertView!.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints([
                NSLayoutConstraint(item: alertView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: alertView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: alertView!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: alertView!, attribute: .right, relatedBy: .equal, toItem: view, attribute: . right, multiplier: 1.0, constant: 0.0)
            ])
        }
        alertView!.addAlert(customView: customView, with: identifier)
    }

    /// 关闭在某视图上执行的提示
    /// - Parameters:
    ///   - view:       执行了提示操作的视图
    ///   - identifier: 提示视图绑定的标识
    public class func hide(in view: UIView, with identifier: String) {
        checkThread()
        for subview in view.subviews {
            if subview.isMember(of: AlertView.classForCoder()) {
                let alertView = subview as! AlertView
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
    public class func showGlobal(_ customView: UIView, with identifier: AlertIdentifier) {
        checkThread()
        AlertWindow.shared.addAlert(customView: customView, with: identifier)
    }

    /// 隐藏指定标识关联的全局提示
    /// - Parameter identifier: 提示视图绑定的标识
    public class func hideGlobal(with identifier: AlertIdentifier) {
        checkThread()
        AlertWindow.shared.removeAlert(with: identifier)
    }
    
}
