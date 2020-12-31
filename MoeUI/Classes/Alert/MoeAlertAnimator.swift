//
//  SheetAnimator.swift
//  MoeUI
//
//  Created by Zed on 2019/8/17.
//
/**
 弹窗转场动画的相关实现
 */

import UIKit
import MoeCommon


/// 转场动画执行协议
public protocol MoeAlertAnimatorProtocol where Self: UIViewController {
    /// 执行动画的内容视图
    func contentViewForAnimation() -> UIView
    /// 执行动画的遮罩视图
    func maskViewForAnimation() -> UIView
}


/// 转场动画执行器
public class MoeAlertAnimator: NSObject {
    /// 转场动作类型
    public enum TransitionType {
        /// 将控制器内容呈现到屏幕上
        case present
        /// 将控制器内容从屏幕上移除
        case dismiss
    }

    /// 转场动画类型
    public enum AnimationType {
        /// 将视图由不透明向指定透明度渐变
        case alpha
        /// 将视图由内向外扩散呈现在目标位置（附带alpha效果）
        case external
        /// 将视图从屏幕底部向目标位置移动呈现（附带alpha效果）；
        /// 携带true则初始时视图顶部与屏幕底部对齐，携带false则初始时视图竖直中心与屏幕底部对齐
        case transformFromBottom(outOffScreen: Bool)
    }

    // MARK: Object Life Cycle
    
    /// 要执行转场动画的控制器
    private var owner: MoeAlertAnimatorProtocol
    /// 转场动作类型
    private var transitionType: TransitionType
    
    /// 底座视图（要呈现的内容将作为子视图添加至底座视图）的圆角值
    public var bezelCornerRadius: CGFloat = 8.0
    /// 转场动画类型
    public var animationType: AnimationType = .transformFromBottom(outOffScreen: false)
    /// 转场动画执行时长
    public var animationDuration: TimeInterval = 0.25
    
    /// 实例化动画执行器
    /// - Parameters:
    ///   - owner:              应用动画执行器的对象
    ///   - transitionType:     转场类型
    ///   - animationDuration:  动画持续时长，默认0.25秒
    public init(owner: MoeAlertAnimatorProtocol, transitionType: TransitionType) {
        self.owner = owner
        self.transitionType = transitionType
    }

    // MARK: Getter & Setter
    
    private var maskView: UIView {
        get { return owner.maskViewForAnimation() }
    }

    private var bezelView: UIView {
        get { return owner.contentViewForAnimation() }
    }
}


// MARK: - 转场动画实现
extension MoeAlertAnimator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case .present:
            animatePresentTransition(using: transitionContext)
        case .dismiss:
            animateDismissTransition(using: transitionContext)
        }
    }
    
    private func animatePresentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let _ = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) as? MoeAlertAnimatorProtocol
        else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        toVC.view.layoutIfNeeded()

        switch animationType {
        case .external:
            externalAnimation(using: transitionContext, transitionType: .present)
            alphaAnimation(using: transitionContext, transitionType: .present)
        case .transformFromBottom(let outOffScreen):
            translationAnimation(in: containerView, using: transitionContext, transitionType: .present, outOffScreen: outOffScreen)
            alphaAnimation(using: transitionContext, transitionType: .present)
        case .alpha:
            alphaAnimation(using: transitionContext, transitionType: .present)
        }
    }

    private func animateDismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? MoeAlertAnimatorProtocol,
            let _ = transitionContext.viewController(forKey: .to)
        else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)

        switch animationType {
        case .external:
            externalAnimation(using: transitionContext, transitionType: .dismiss)
            alphaAnimation(using: transitionContext, transitionType: .dismiss)
        case .transformFromBottom(let outOffScreen):
            translationAnimation(in: containerView, using: transitionContext, transitionType: .dismiss, outOffScreen: outOffScreen)
            alphaAnimation(using: transitionContext, transitionType: .dismiss)
        case .alpha:
            alphaAnimation(using: transitionContext, transitionType: .dismiss)
        }
    }
}


// MARK: - 基础动画
extension MoeAlertAnimator: CAAnimationDelegate {
    private func basicAnimation(keyPath: String, duration: TimeInterval, transitionType: TransitionType) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.setValue(transitionType, forKey: "TRANSITION_TYPE")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = duration
        return animation
    }
    
    // 透明动画
    private func alphaAnimation(using transitionContext: UIViewControllerContextTransitioning, transitionType: TransitionType) {
        let maskAlpha = maskView.alpha
        let bezelAlpha = bezelView.alpha
        let duration = self.transitionDuration(using: transitionContext)
        
        let bezelAlphaAnim = basicAnimation(keyPath: "opacity", duration: duration, transitionType: transitionType)
        let maskAlphaAnim = basicAnimation(keyPath: "opacity", duration: duration, transitionType: transitionType)
        if transitionType == .present {
            bezelAlphaAnim.fromValue = 0.0
            bezelAlphaAnim.toValue = bezelAlpha
            maskAlphaAnim.fromValue = 0.0
            maskAlphaAnim.toValue = maskAlpha
        } else if transitionType == .dismiss {
            bezelAlphaAnim.fromValue = bezelAlpha
            bezelAlphaAnim.toValue = 0.0
            maskAlphaAnim.fromValue = maskAlpha
            maskAlphaAnim.toValue = 0.0
        }

        maskView.layer.add(maskAlphaAnim, forKey: "maskOpacityAnimation")
        bezelView.layer.add(bezelAlphaAnim, forKey: "bezelOpacityAnimation")
    }

    // 平移动画
    private func translationAnimation(
        in containerView: UIView,
        using transitionContext: UIViewControllerContextTransitioning,
        transitionType: TransitionType,
        outOffScreen: Bool
    ) {
        let bezelPosition = bezelView.center
        let delta = outOffScreen ? 0 : bezelView.frame.height / 2
        let bezelTargetPosition = CGPoint(x: bezelPosition.x, y: containerView.frame.height - delta)
        
        let bezelPositionAnim = basicAnimation(
            keyPath: "position",
            duration: self.transitionDuration(using: transitionContext),
            transitionType: transitionType
        )
        bezelPositionAnim.delegate = self
        bezelPositionAnim.setValue(transitionContext, forKey: "transitionContext")

        if transitionType == .present {
            bezelPositionAnim.fromValue = bezelTargetPosition
            bezelPositionAnim.toValue = bezelPosition
        } else if transitionType == .dismiss {
            bezelPositionAnim.fromValue = bezelPosition
            bezelPositionAnim.toValue = bezelTargetPosition
        }
        bezelView.layer.add(bezelPositionAnim, forKey: "bezelPositionAnimation")
    }
    
    // 缩放动画
    private func externalAnimation(using transitionContext: UIViewControllerContextTransitioning, transitionType: TransitionType) {
        let bezelCornerRadii = CGSize(width: bezelCornerRadius, height: bezelCornerRadius)
        let sourceRect = CGRect(x: bezelView.bounds.width / 2,
                                y: bezelView.bounds.height / 2,
                                width: bezelCornerRadius * 2,
                                height: bezelCornerRadius * 2)
        let sourcePath = UIBezierPath(roundedRect: sourceRect, byRoundingCorners: .allCorners, cornerRadii: bezelCornerRadii)
        let destinPtah = UIBezierPath(roundedRect: bezelView.bounds, byRoundingCorners: .allCorners, cornerRadii: bezelCornerRadii)
        let mask = CAShapeLayer()

        let bezelMaskPathAnim = basicAnimation(
            keyPath: "path",
            duration: self.transitionDuration(using: transitionContext),
            transitionType: transitionType
        )
        bezelMaskPathAnim.delegate = self
        bezelMaskPathAnim.setValue(mask, forKey: "mask")
        bezelMaskPathAnim.setValue(transitionContext, forKey: "transitionContext")

        if transitionType == .present {
            bezelMaskPathAnim.fromValue = sourcePath.cgPath
            bezelMaskPathAnim.toValue = destinPtah.cgPath
            mask.path = destinPtah.cgPath
        } else if transitionType == .dismiss {
            bezelMaskPathAnim.fromValue = destinPtah.cgPath
            bezelMaskPathAnim.toValue = sourcePath.cgPath
            mask.path = sourcePath.cgPath
        }

        mask.add(bezelMaskPathAnim, forKey: "bezelPathAnimation")
        bezelView.layer.mask = mask
    }
    
    // MARK: CAAnimationDelegate
    
    public func animationDidStart(_ anim: CAAnimation) {
        MLog("动画开始")
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        MLog("动画结束")
        // 1. 执行动画处理的收尾处理（避免闪屏）
//        let transitionType = anim.value(forKey: "TRANSITION_TYPE") as? TransitionType
        // 2. 移除动画效果
        if let mask = anim.value(forKey: "mask") as? CAShapeLayer { mask.removeFromSuperlayer() }
        // 3. 完成转场动画
        if let transitionContext = anim.value(forKey: "transitionContext") as? UIViewControllerContextTransitioning {
            transitionContext.completeTransition(flag)
        }
    }
}

