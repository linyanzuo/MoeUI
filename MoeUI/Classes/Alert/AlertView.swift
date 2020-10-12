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
    /// 是否启用动画
    public var useAnaimation = true
    /// 是否启用遮罩
    public var maskEnable = true { didSet { maskBtn.isHidden = !maskEnable } }
    /// 遮罩被点击时执行的回调闭包
    public var maskTapHandler: (() -> Void)?
    /// 提示视图隐藏后的执行回调闭包
    public var completionHandler: (() -> Void)?
    /// 提示视图隐藏时，是否将AlertView从父视图上移除
    public var removeFromSuperViewOnHide = true
    
    private let kMaskAlpha: CGFloat = 0.4
    private let kMaskAnimKey = "MASK_ANIMATION"
    private let kContentAnimKey = "CONTENT_ANIMATION"
    
    private(set) var alerts: [Alert] = []       // 记录所有提示（标识，内容）
    private var contentViewAlpha: CGFloat = 1.0  // 记录待弹出视图的原透明度

//    deinit {
//        MLog("[\(self)] died!")
//    }

    /// 子视图初始化，子类可重写该方法修改配置或添加视图，记得调用`super`
    override public func setupSubview() {
        self.backgroundColor = .clear
        
        maskBtn.isHidden = !maskEnable
        maskTapHandler = { [weak self] in
            self?.removeAlert(completionHandler: nil)
        }
        self.addSubview(maskBtn)
    }
    
    /// 子视图约束初始化，默认为覆盖父视图
    /// 子类应根据实际需求，重写该方法完成约束的配置，不需要调用`super`
    override public func setupConstraint() {
        maskBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: maskBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        ])
    }

    // MARK: Getter & Setter
    private(set) lazy var maskBtn: UIButton = {
        let dtor = Designator()
        dtor.general.alpha(1.0)
        dtor.background(UIColor(rgb: 0x484848))
        dtor.event(.touchUpInside, for: self, action: #selector(self.maskTapAction(_:)))
        return dtor.makeButton()
    }()
}


// MARK: - 提示操作
extension AlertView {
    /// 添加新提示
    /// - Parameters:
    ///   - customView: 提示的展示内容
    ///   - identifier: 提示的唯一标识
    public func addAlert(customView: UIView, with identifier: String? = nil) {
        // 1. 清除上一个提示的动画效果，避免动画效果冲突
        if let previousView = alerts.last?.view { previousView.layer.removeAllAnimations() }
        // 2. 检查提示标识是否冲突（重复）
        let id = identifier ?? Alerter.generateIdentifier()
        for alert in alerts {
            guard alert.id != id else {
                MLog("标识值「\(id)」已被使用")
                return
            }
        }
        // 3. 记录新提示
        let alert = Alert(id: id, view: customView)
        if alerts.count > 0 { bringSubviewToFront(maskBtn) }
        alerts.append(alert)
        // 4. 添加提示内容
        addSubview(alert.view)
        customView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            NSLayoutConstraint(item: customView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: customView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: customView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .left, multiplier: 1.0, constant: 24),
            NSLayoutConstraint(item: customView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: self, attribute: .right, multiplier: 1.0, constant: -24)
        ])
        // 5. 添加动画效果
        if useAnaimation == true {
            addContentAnimation(to: alert, transitionType: .present)
            if alerts.count == 1 { addMaskAnimation(transitionType: .present) }
        }
    }
    
    /// 移除已存在的提示
    /// - Parameters:
    ///   - identifier:         提示的唯一标识，不指定时则使用展示在最顶层的提示
    ///   - completionHandler:  移动完成后执行的闭包
    public func removeAlert(with identifier: String? = nil, completionHandler: (() -> Void)?) {
        // 1. 清除上一个提示的动画效果，避免动画效果冲突
        if let previousView = alerts.last?.view { previousView.layer.removeAllAnimations() }
        maskBtn.isUserInteractionEnabled = false
        guard alerts.count > 0 else {
            MLog("没有正在展示的提示")
            return
        }
        self.completionHandler = completionHandler
        // 2. 查找要移除的目标提示
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
        // 3. 判断遮罩按钮是否移除
        let shouldMaskDismiss = alerts.count <= 1 ? true : false
        // 4. 是否使用动画；动画结束时调用`removeAlertComplete`
        if useAnaimation == true {
            addContentAnimation(to: targetAlert!, transitionType: .dismiss)
            if shouldMaskDismiss == true { addMaskAnimation(transitionType: .dismiss) }
        }
        else { removeAlertComplete(with: targetAlert!) }
    }

    /// 移除提示结束后的操作
    private func removeAlertComplete(with alert: Alert) {
        // 1. 查找提示视图，并从父视图上移除
        for index in 0 ..< alerts.count {
            if alerts[index].id == alert.id {
                alerts.remove(at: index)
                break
            }
        }
        alert.view.removeFromSuperview()
        // 2. 若包含多个提示视图，则将下个提示视图置顶
        if alerts.count >= 1, let previousView = alerts.last?.view {
            bringSubviewToFront(previousView)
        } else if alerts.count == 0 && removeFromSuperViewOnHide == true {
            self.removeFromSuperview()
        }
        completionHandler?()
    }
}


// MARK: - 基础动画
extension AlertView: CAAnimationDelegate {
    /// 子类可重写该方法，自定义动画持续时长，默认为0.25秒
    /// - Returns: 动画持续时长
    open func animationDuration() -> TimeInterval {
        return 0.25
    }
    
    /// 转场类型
    public enum TransitionType {
        case present
        case dismiss
    }
    
    /// 创建基础动画
    private func basicAnimation(keyPath: String, name: String, type: TransitionType) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.setValue(name, forKey: "NAME")
        animation.setValue(type, forKey: "TRANSACTION_TYPE")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = animationDuration()
        animation.delegate = self
        return animation
    }

    /// 遮罩按钮添加动画效果
    private func addMaskAnimation(transitionType: TransitionType) {
        maskBtn.isUserInteractionEnabled = false
        
        let maskAnim = basicAnimation(keyPath: "opacity", name: "MaskAnimation", type: transitionType)
        if transitionType == .present {
            maskAnim.fromValue = 0.0
            maskAnim.toValue = kMaskAlpha
            maskBtn.alpha = 0.0
        } else if transitionType == .dismiss {
            maskAnim.fromValue = kMaskAlpha
            maskAnim.toValue = 0.0
            maskBtn.alpha = kMaskAlpha
        }
        maskBtn.layer.add(maskAnim, forKey: kMaskAnimKey)
    }
    
    /// 遮罩按钮动画结束处理
    private func maskAnimationDidStop(type: TransitionType) {
        maskBtn.alpha = type == .present ? kMaskAlpha : 0.0
        maskBtn.isUserInteractionEnabled = true
    }
    
    /// 提示视图添加动画效果
    private func addContentAnimation(to alert: Alert, transitionType: TransitionType) {
        let contentView = alert.view
        contentViewAlpha = contentView.alpha
        
        let contentAnim = basicAnimation(keyPath: "opacity", name: "AlertAnimation", type: transitionType)
        contentAnim.setValue(alert, forKey: "Alert")
        if transitionType == .present {
            contentAnim.fromValue = 0.0
            contentAnim.toValue = contentViewAlpha
            contentView.alpha = 0.0
        } else if transitionType == .dismiss {
            contentAnim.fromValue = contentViewAlpha
            contentAnim.toValue = 0.0
            contentView.alpha = contentViewAlpha
        }
        contentView.layer.add(contentAnim, forKey: kContentAnimKey)
    }
    
    /// 提示视图动画结束处理
    private func alertAnimationDidStop(alert: Alert, type: TransitionType) {
        alert.view.alpha = contentViewAlpha
        maskBtn.isUserInteractionEnabled = true
        if type == .dismiss { self.removeAlertComplete(with: alert) }
    }

    // MARK: CAAnimationDelegate
    public func animationDidStart(_ anim: CAAnimation) {
        debugPrint("AlertView 动画开始")
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        debugPrint("AlertView 动画结束")
        guard let animName = anim.value(forKey: "NAME") as? String,
              let transitionType = anim.value(forKey: "TRANSACTION_TYPE") as? TransitionType
        else { return }
        
        switch animName {
        case "MaskAnimation":
            maskAnimationDidStop(type: transitionType)
        case "AlertAnimation":
            let alert = anim.value(forKey: "Alert") as! Alert
            alertAnimationDidStop(alert: alert, type: transitionType)
        default: break
        }
    }
}


// MARK: - 事件响应
@objc extension AlertView {
    @objc func maskTapAction(_ sender: UIButton) {
        maskTapHandler?()
    }
}
