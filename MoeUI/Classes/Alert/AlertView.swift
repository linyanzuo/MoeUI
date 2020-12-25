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
    /// 动画效果类型
    public var animationType: AnimationType = .alpha
    /// 是否启用遮罩
    public var maskEnable = true { didSet { maskBtn.isHidden = !maskEnable } }
    /// 点击遮罩时是否关闭提示视图
    public var hideWhenMaskTap = true
    /// 遮罩被点击时执行的回调闭包
    public var maskTapHandler: (() -> Void)?
    /// 提示视图隐藏后的执行回调闭包
    public var completionHandler: (() -> Void)?
    /// 提示视图隐藏时，是否将AlertView从父视图上移除
    public var removeFromSuperViewOnHide = true
    
    private let kMaskAlpha: CGFloat = 0.4                                   /// 遮罩层的透明度
//    private let kMaskAnimKey = "MASK_ANIMATION"
//    private let kContentAnimKey = "CONTENT_ANIMATION"
    
    // XXXAnimName即被用作Layer的动画标识（添加或删除动画），也被用于动画执行过程中作为动画名称进行识别（动画开始及结束的处理）
    private let MaskAnimName = "MaskAlphaAnimation"                         /// 遮罩透明动画名
    private let ContentAlphaAnimName = "AlertAplhaAnimation"                /// 提示透明动画名
    private let ContentTranslationAnimName = "AlertTransformAnimation"      /// 提示位移动画名
    
    private(set) var alerts: [Alert] = []       // 记录所有提示（标识，内容）
    private var contentViewAlpha: CGFloat = 1.0  // 记录待弹出视图的原透明度

//    deinit {
//        MLog("[\(self)] died!")
//    }

    /// 子视图初始化，子类可重写该方法修改配置或添加视图，记得调用`super`
    override open func setupSubview() {
        self.backgroundColor = .clear
        
        maskBtn.isHidden = !maskEnable
        self.addSubview(maskBtn)
    }
    
    /// 子视图约束初始化，默认为覆盖父视图
    /// 子类应根据实际需求，重写该方法完成约束的配置，不需要调用`super`
    override open func setupConstraint() {
        maskBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: maskBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        ])
    }
    
    /// 在此方法中配置内容视图与弹窗的约束。内容视图将作为子视图，添加至弹窗
    /// - Parameter contentView: 内容视图
    open func setupContentConstraint(contentView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .left, multiplier: 1.0, constant: 24),
            NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: self, attribute: .right, multiplier: 1.0, constant: -24)
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
//        MLog("新增提示")
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
        addSubview(customView)
        setupContentConstraint(contentView: customView)
        // 5. 添加动画效果
        if useAnaimation == true {
            MLog("Frmae of AlertView's SuperView: \(self.superview!.frame)")
            addContentAnimation(to: alert, transitionType: .present)
            if alerts.count == 1 { addAnimationForMaskBtn(to: alert, transitionType: .present) }
        }
    }
    
    /// 移除已存在提示前的预操作，如执行过渡动画等
    /// - Parameters:
    ///   - identifier:         提示的唯一标识，不指定时则使用展示在最顶层的提示
    ///   - completionHandler:  移动完成后执行的闭包
    public func prepareToRemoveAlert(with identifier: String? = nil, completionHandler: (() -> Void)?) {
//        MLog("移除提示")
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
            // 为弹窗内容添加动画
            addContentAnimation(to: targetAlert!, transitionType: .dismiss)
            // 为遮罩按钮添加动画
            if shouldMaskDismiss == true {
                addAnimationForMaskBtn(to: targetAlert!, transitionType: .dismiss)
            } else {
                removeAlert(with: targetAlert!)
            }
        }
        else { removeAlert(with: targetAlert!) }
    }

    /// 移除提示后执行的操作
    /// - Parameter alert:
    private func removeAlert(with alert: Alert) {
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


// MARK: - 事件响应
@objc extension AlertView {
    @objc func maskTapAction(_ sender: UIButton) {
        MLog("【AlertView】点击了遮罩按钮")
        // 启用点击遮罩关闭弹窗时，移除弹窗
        if hideWhenMaskTap { self.prepareToRemoveAlert(completionHandler: nil) }
        // 执行自定义遮罩点击事件
        maskTapHandler?()
    }
}


// MARK: - 基础动画
extension AlertView: CAAnimationDelegate {
    public enum AnimationType {
        /// 将视图由内向外扩散呈现在目标位置（附带alpha效果）
//        case external
        /// 将视图从屏幕底部向目标位置移动呈现（附带alpha效果）；
        /// 携带true则初始时视图顶部与屏幕底部对齐，携带false则初始时视图底部与屏幕底部对齐
        case transformFromBottom(outOffScreen: Bool)
        /// 将视图由不透明向指定透明度渐变
        case alpha
    }
    
    /// 展示类型
    public enum TransitionType {
        case present
        case dismiss
    }
    
    /// 子类可重写该方法，自定义动画持续时长，默认为0.25秒
    /// - Returns: 动画持续时长
    open func animationDuration() -> TimeInterval {
        return 0.25
    }
    
    /// 创建基础动画
    private func basicAnimation(keyPath: String, name: String, type: TransitionType, alert: Alert) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.setValue(name, forKey: "NAME")
        animation.setValue(type, forKey: "TRANSACTION_TYPE")
        animation.setValue(alert, forKey: "ALERT")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = animationDuration()
        animation.delegate = self
        return animation
    }
    
    /// 提示视图添加`animationType`动画
    private func addContentAnimation(to alert: Alert, transitionType: TransitionType) {
        // 根据动画类型，为提示视图添加匹配的动画。
        // 动画结束(`animationDidStart`)时，根据动画类型执行相应的结束操作
        switch animationType {
        case .alpha:
            addAlphaAnimation(to: alert, transitionType: transitionType)
        case .transformFromBottom(let outOffScreen):
            addTranslationAnimation(to: alert, transitionType: transitionType, outOffScreen: outOffScreen)
            addAlphaAnimation(to: alert, transitionType: transitionType)
        }
    }

    // MARK: CAAnimationDelegate
    
    public func animationDidStart(_ anim: CAAnimation) {
        guard let animName = anim.value(forKey: "NAME") as? String,
              let transitionType = anim.value(forKey: "TRANSACTION_TYPE") as? TransitionType
        else { return }
        MLog("【AlertView】动画：\(animName)，过渡类型：\(transitionType)，开始执行")
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let animName = anim.value(forKey: "NAME") as? String,
              let transitionType = anim.value(forKey: "TRANSACTION_TYPE") as? TransitionType
        else { return }
        MLog("【AlertView】动画：\(animName)，过渡类型：\(transitionType)，执行结束")
        
        let alert = anim.value(forKey: "ALERT") as! Alert
        switch animName {
        case MaskAnimName:
            maskBtnAnimationDidStop(alert: alert, type: transitionType)
        case ContentAlphaAnimName:
            alphaAnimationDidStop(contentView: alert.view, type: transitionType)
        case ContentTranslationAnimName:
            translationAnimationDidStop(contentView: alert.view, type: transitionType)
        default: break
        }
    }
}


// MARK: - 遮罩按钮动画
extension AlertView {
    /// 遮罩按钮添加透明度渐变动画
    private func addAnimationForMaskBtn(to alert: Alert, transitionType: TransitionType) {
        maskBtn.isUserInteractionEnabled = false
        
        let maskAnim = basicAnimation(keyPath: "opacity", name: MaskAnimName, type: transitionType, alert: alert)
        if transitionType == .present {
            maskAnim.fromValue = 0.0
            maskAnim.toValue = kMaskAlpha
            maskBtn.alpha = 0.0
        } else if transitionType == .dismiss {
            maskAnim.fromValue = kMaskAlpha
            maskAnim.toValue = 0.0
            maskBtn.alpha = kMaskAlpha
        }
        maskBtn.layer.add(maskAnim, forKey: MaskAnimName)
    }
    
    /// 遮罩按钮动画结束处理
    private func maskBtnAnimationDidStop(alert: Alert, type: TransitionType) {
        maskBtn.alpha = type == .present ? kMaskAlpha : 0.0
        maskBtn.isUserInteractionEnabled = true
        maskBtn.layer.removeAnimation(forKey: MaskAnimName)
        // 遮罩动画完成时，还要负责将Alert移除（只有遮罩会触发移除的事件）
        if type == .dismiss { self.removeAlert(with: alert) }
    }
}


// MARK: - 提示视图渐变动画
extension AlertView {
    /// 添加透明度渐变动画
    private func addAlphaAnimation(to alert: Alert, transitionType: TransitionType) {
        let contentView = alert.view
        contentViewAlpha = contentView.alpha
        
        let contentAnim = basicAnimation(keyPath: "opacity", name: ContentAlphaAnimName, type: transitionType, alert: alert)
        if transitionType == .present {
            contentAnim.fromValue = 0.0
            contentAnim.toValue = contentViewAlpha
            contentView.alpha = 0.0
        } else if transitionType == .dismiss {
            contentAnim.fromValue = contentViewAlpha
            contentAnim.toValue = 0.0
            contentView.alpha = contentViewAlpha
        }
        contentView.layer.add(contentAnim, forKey: ContentAlphaAnimName)
    }
    
    /// 透明度渐变动画结束处理
    private func alphaAnimationDidStop(contentView: UIView, type: TransitionType) {
        contentView.alpha = type == .present ? contentViewAlpha : 0.0
        contentView.layer.removeAnimation(forKey: ContentAlphaAnimName)
    }
}


// MARK: - 提示视图位移动画
extension AlertView {
    /// 添加位置移动动画（从底部移出来）
    private func addTranslationAnimation(to alert: Alert, transitionType: TransitionType, outOffScreen: Bool) {
        let contentView = alert.view
        let selfSize = self.frame.size
        let customSize = contentView.systemLayoutSizeFitting(selfSize)

        let visibleCenter = CGPoint(x: selfSize.width / 2.0, y: selfSize.height - customSize.height / 2.0)
        let delta = outOffScreen ? customSize.height / 2.0 : 0
        let invisibleCenter = CGPoint(x: visibleCenter.x, y: selfSize.height + delta)

        let contentPositionAnim = basicAnimation(keyPath: "position", name: ContentTranslationAnimName, type: transitionType, alert: alert)
        if transitionType == .present {
            contentPositionAnim.fromValue = invisibleCenter
            contentPositionAnim.toValue = visibleCenter
        } else if transitionType == .dismiss {
            contentPositionAnim.fromValue = visibleCenter
            contentPositionAnim.toValue = invisibleCenter
        }
        contentView.layer.add(contentPositionAnim, forKey: ContentTranslationAnimName)
    }
    
    /// 位置移动动画结束处理
    private func translationAnimationDidStop(contentView: UIView, type: TransitionType) {
        contentView.layer.removeAnimation(forKey: ContentTranslationAnimName)
    }
}
