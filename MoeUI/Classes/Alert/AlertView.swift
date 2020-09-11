//
//  MaskAlertView.swift
//  MoeUI
//
//  Created by Zed on 2019/9/8.
//
/**
 【提示】提示视图
 */

import UIKit
import MoeCommon


/// 提示
struct Alert {
    /// 提示的标识，作唯一识别用
    var id: String
    /// 提示的内容，作弹出展示用
    var view: UIView
}


/// 提示视图
/// 所有要弹出展示的提示内容，都作为它的子视图进行管理。
open class AlertView: View {
    let kMaskAlpha: CGFloat = 0.4
    let kCustomOpacityAnimKey = "customOpacityAnimation"
    let kMaskOpacityAnimKey = "maskOpacityAnimation"

    /// 是否启用遮罩
    public var maskEnable = true { didSet { maskBtn.isHidden = !maskEnable } }
    /// 遮罩被点击时执行的回调闭包
    public var maskTapHandler: (() -> Void)?
    /// 是否启用动画
    public var useAnaimation = true
    /// 提示视图隐藏时，是否从父视图上移动
    public var removeFromSuperViewOnHide = true
    /// 提示视图隐藏后的执行回调闭包
    public var completionHandler: (() -> Void)?
    
    private(set) var alerts: [Alert] = []       // 记录所有提示（标识，内容）
    private var customViewAlpha: CGFloat = 0.0  // 记录待弹出视图的原透明度

    deinit {
        MLog("[\(self)] died!")
    }

    override public func setupSubview() {
        self.backgroundColor = .clear
        self.addSubview(maskBtn)
        maskBtn.isHidden = !maskEnable

        maskTapHandler = {
            self.removeAlert(completionHandler: nil)
        }
    }

    override public func setupConstraint() {
        maskBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: maskBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        ])
    }
    
    /// 添加新提示
    /// - Parameters:
    ///   - customView: 提示的展示内容
    ///   - identifier: 提示的唯一标识
    public func addAlert(customView: UIView, with identifier: String? = nil) {
        if let previousView = alerts.last?.view { previousView.layer.removeAllAnimations() }
        maskBtn.isUserInteractionEnabled = false
        customViewAlpha = customView.alpha
        let id = identifier ?? Alerter.generateIdentifier()
        for alert in alerts {
            if alert.id == id {
                MLog("标识值「\(id)」已被使用")
                return
            }
        }
        // 记录新提示
        let alert = Alert(id: id, view: customView)
        if alerts.count > 0 { bringSubviewToFront(maskBtn) }
        alerts.append(alert)
        // 添加提示内容
        addSubview(alert.view)
        customView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            NSLayoutConstraint(item: customView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: customView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .left, multiplier: 1.0, constant: 24),
            NSLayoutConstraint(item: customView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: self, attribute: .right, multiplier: 1.0, constant: -24)
        ])
        // 添加动画效果
        if useAnaimation == true {
            addAlphaAnimation(to: alert, transitionType: .present)
            if alerts.count == 0 { addMaskAnimation(transitionType: .present) }
        }
        else { maskBtn.isUserInteractionEnabled = true }
    }
    
    /// 移除已存在的提示
    /// - Parameters:
    ///   - identifier:         提示的唯一标识，不指定时则使用展示在最顶层的提示
    ///   - completionHandler:  移动完成后执行的闭包
    public func removeAlert(with identifier: String? = nil, completionHandler: (() -> Void)?) {
        if let previousView = alerts.last?.view { previousView.layer.removeAllAnimations() }
        maskBtn.isUserInteractionEnabled = false
        guard alerts.count > 0 else {
            MLog("没有正在展示的提示")
            return
        }
        self.completionHandler = completionHandler

        // 查找要移除的目标提示
        var targetAlert: Alert? = alerts.last
        if identifier != nil {
            for alert in alerts {
                if alert.id == identifier {
                    targetAlert = alert
                    break
                }
            }
            if targetAlert == nil {
                MLog("找不到与指定标识\(identifier!)匹配的提示")
                return
            }
        }

        var shouldMaskDismiss = false
        if alerts.count <= 1 { shouldMaskDismiss = true }
        // 添加动画
        if useAnaimation == true {
            addAlphaAnimation(to: targetAlert!, transitionType: .dismiss)
            if shouldMaskDismiss == true { addMaskAnimation(transitionType: .dismiss) }
        }
        else { done(with: targetAlert!) }
    }

    /// 移除提示的结束操作
    private func done(with alert: Alert) {
        for index in 0 ..< alerts.count {
            if alerts[index].id == alert.id {
                alerts.remove(at: index)
                break
            }
        }
        alert.view.removeFromSuperview()

        if alerts.count >= 1 {
            if let previousView = alerts.last?.view { bringSubviewToFront(previousView) }
        } else if alerts.count == 0 && removeFromSuperViewOnHide == true {
            self.removeFromSuperview()
        }
        maskBtn.isUserInteractionEnabled = true
        completionHandler?()
    }

    // MARK: Getter & Setter
    private(set) lazy var maskBtn: UIButton = {
        let des = Designator()
        des.general.alpha(kMaskAlpha)
        des.background(UIColor(rgb: 0x484848))
        des.event(.touchUpInside, for: self, action: #selector(self.maskTapAction(_:)))
        return des.makeButton()
    }()
}


// MARK: - 提示视图 + 事件响应
@objc extension AlertView {
    @objc func maskTapAction(_ sender: UIButton) {
        maskTapHandler?()
    }
}


// MARK: - 提示视图 + 动画效果
extension AlertView: CAAnimationDelegate {
    public enum TransitionType {
        case present
        case dismiss
    }

    private func animationDuration() -> TimeInterval {
        return 0.25
    }

    private func addMaskAnimation(transitionType: TransitionType) {
        let maskAlphaAnim = CABasicAnimation(keyPath: "opacity")
        maskAlphaAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskAlphaAnim.isRemovedOnCompletion = true
        maskAlphaAnim.duration = animationDuration()
        maskAlphaAnim.delegate = self

        if transitionType == .present {
            maskAlphaAnim.fromValue = 0.0
            maskAlphaAnim.toValue = kMaskAlpha
            maskBtn.alpha = kMaskAlpha
        } else if transitionType == .dismiss {
            maskAlphaAnim.fromValue = kMaskAlpha
            maskAlphaAnim.toValue = 0.0
            maskBtn.alpha = 0.0
        }
        maskBtn.layer.add(maskAlphaAnim, forKey: kMaskOpacityAnimKey)
    }

    private func addAlphaAnimation(to alert: Alert, transitionType: TransitionType) {
        let customAlphaAnim = CABasicAnimation(keyPath: "opacity")
        customAlphaAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        customAlphaAnim.isRemovedOnCompletion = true
        customAlphaAnim.duration = animationDuration()
        customAlphaAnim.delegate = self
        customAlphaAnim.setValue(alert, forKey: "alert")
        customAlphaAnim.setValue(transitionType, forKey: "transitionType")

        let customView = alert.view
        if transitionType == .present {
            customAlphaAnim.fromValue = 0.0
            customAlphaAnim.toValue = customViewAlpha
            customView.alpha = customViewAlpha
        } else if transitionType == .dismiss {
            customAlphaAnim.fromValue = customViewAlpha
            customAlphaAnim.toValue = 0.0
            customView.alpha = 0.0
        }
        customView.layer.add(customAlphaAnim, forKey: kCustomOpacityAnimKey)
    }

    // MARK: CAAnimationDelegate
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let alert = anim.value(forKey: "alert") as? Alert,
            let transitionType = anim.value(forKey: "transitionType") as? TransitionType
        {
            if transitionType == .dismiss { self.done(with: alert) }
            else { maskBtn.isUserInteractionEnabled = true }
        }
//        MLog("Animation did stop")
    }
}
