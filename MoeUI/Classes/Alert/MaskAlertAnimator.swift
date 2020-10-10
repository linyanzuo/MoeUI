//
//  SheetAnimator.swift
//  MoeUI
//
//  Created by Zed on 2019/8/17.
//

import UIKit


/// 转场动画执行协议
public protocol MaskAlertAnimatorProtocol where Self: UIViewController {
    func contentViewForAnimation() -> UIView
    func maskViewForAnimation() -> UIView
}


/// 转场动画执行器
public class MaskAlertAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    public enum TransitionType {
        case present
        case dismiss
    }

    public enum AnimationType {
        /// 将视图由内向外扩散呈现在目标位置（附带alpha效果）
        case external
        /// 将视图从屏幕底部向目标位置移动呈现（附带alpha效果）；
        /// 携带true则初始时视图顶部与屏幕底部对齐，携带false则初始时视图底部与屏幕底部对齐
        case transformFromBottom(outOffScreen: Bool)
        /// 将视图由不透明向指定透明度渐变
        case alpha
    }

    private let kBezelCornerRadius: CGFloat = 8.0

    // MARK: Object Life Cycle
    var owner: MaskAlertAnimatorProtocol
    var transitionType: TransitionType
    var animationType: AnimationType
    var animationDuration: TimeInterval

    
    /// 实例化动画执行器
    /// - Parameters:
    ///   - owner:              应用动画执行器的对象
    ///   - transitionType:     转场类型
    ///   - animationType:      动画类型
    ///   - animationDuration:  动画持续时长
    public init(
        owner: MaskAlertAnimatorProtocol,
        transitionType: TransitionType,
        animationType: AnimationType = .transformFromBottom(outOffScreen: false),
        animationDuration: TimeInterval = 0.25
    ) {
        self.owner = owner
        self.transitionType = transitionType
        self.animationType = animationType
        self.animationDuration = animationDuration
    }

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

    // MARK: Private Method
    private func animatePresentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let _ = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) as? MaskAlertAnimatorProtocol
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
        guard let fromVC = transitionContext.viewController(forKey: .from) as? MaskAlertAnimatorProtocol,
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

    // MARK: Getter & Setter
    private var maskView: UIView {
        get { return owner.maskViewForAnimation() }
    }

    private var bezelView: UIView {
        get { return owner.contentViewForAnimation() }
    }
}


// MARK: - 动画
extension MaskAlertAnimator {
    private func basicAnimation(keyPath: String, duration: TimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
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
        
        let bezelAlphaAnim = basicAnimation(keyPath: "opacity", duration: duration)
        let maskAlphaAnim = basicAnimation(keyPath: "opacity", duration: duration)

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
    private func translationAnimation(in containerView: UIView, using transitionContext: UIViewControllerContextTransitioning, transitionType: TransitionType, outOffScreen: Bool) {
        let bezelPosition = bezelView.center
        let delta = outOffScreen ? 0 : bezelView.frame.height / 2
        let bezelTargetPosition = CGPoint(x: bezelPosition.x, y: containerView.frame.height - delta)
        
        let bezelPositionAnim = basicAnimation(keyPath: "position", duration: self.transitionDuration(using: transitionContext))
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
        let bezelCornerRadii = CGSize(width: kBezelCornerRadius, height: kBezelCornerRadius)
        let sourceRect = CGRect(x: bezelView.bounds.width / 2,
                                y: bezelView.bounds.height / 2,
                                width: kBezelCornerRadius * 2,
                                height: kBezelCornerRadius * 2)
        let sourcePath = UIBezierPath(roundedRect: sourceRect, byRoundingCorners: .allCorners, cornerRadii: bezelCornerRadii)
        let destinPtah = UIBezierPath(roundedRect: bezelView.bounds, byRoundingCorners: .allCorners, cornerRadii: bezelCornerRadii)
        let mask = CAShapeLayer()

        let bezelMaskPathAnim = basicAnimation(keyPath: "path", duration: self.transitionDuration(using: transitionContext))
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
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let mask = anim.value(forKey: "mask") as? CAShapeLayer { mask.removeFromSuperlayer() }
        if let transitionContext = anim.value(forKey: "transitionContext") as? UIViewControllerContextTransitioning {
            transitionContext.completeTransition(flag)
        }
    }
}

