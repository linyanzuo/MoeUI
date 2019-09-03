//
//  SheetAnimator.swift
//  MoeUI
//
//  Created by Zed on 2019/8/17.
//

import UIKit


public protocol MaskAlertAnimatorProtocol where Self: UIViewController {
    func contentViewForAnimation() -> UIView
    func maskViewForAnimation() -> UIView
}


/// Transition Animation Performer
public class MaskAlertAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    public enum TransitionType {
        case present
        case dismiss
    }

    public enum AnimationType {
        /// tiled content from inner to external
        case external
        /// translate content from bottom to target position
        case translation
    }

    private let kBezelCornerRadius: CGFloat = 8.0

    // MARK: Object Life Cycle
    var owner: MaskAlertAnimatorProtocol
    var transitionType: TransitionType
    var animationType: AnimationType

    public init(owner: MaskAlertAnimatorProtocol, transitionType: TransitionType, animationType: AnimationType = .translation) {
        self.owner = owner
        self.transitionType = transitionType
        self.animationType = animationType
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
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
        case .translation:
            translationAnimation(in: containerView, using: transitionContext, transitionType: .present)
        }
        alphaAnimation(using: transitionContext, transitionType: .present)
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
        case .translation:
            translationAnimation(in: containerView, using: transitionContext, transitionType: .dismiss)
        }
        alphaAnimation(using: transitionContext, transitionType: .dismiss)
    }

    // MARK: Animation
    private func translationAnimation(in containerView: UIView, using transitionContext: UIViewControllerContextTransitioning, transitionType: TransitionType) {
        let bezelPosition = bezelView.center
        let bezelTargetPosition = CGPoint(x: bezelPosition.x,
                                          y: containerView.frame.height - bezelView.frame.height / 2)

        let bezelPositionAnim = CABasicAnimation(keyPath:"position")
        bezelPositionAnim.delegate = self
        bezelPositionAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        bezelPositionAnim.isRemovedOnCompletion = true
        bezelPositionAnim.duration = self.transitionDuration(using: transitionContext)
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

    private func externalAnimation(using transitionContext: UIViewControllerContextTransitioning, transitionType: TransitionType) {
        let bezelCornerRadii = CGSize(width: kBezelCornerRadius, height: kBezelCornerRadius)
        let sourceRect = CGRect(x: bezelView.bounds.width / 2,
                                y: bezelView.bounds.height / 2,
                                width: kBezelCornerRadius * 2,
                                height: kBezelCornerRadius * 2)
        let sourcePath = UIBezierPath(roundedRect: sourceRect, byRoundingCorners: .allCorners, cornerRadii: bezelCornerRadii)
        let destinPtah = UIBezierPath(roundedRect: bezelView.bounds, byRoundingCorners: .allCorners, cornerRadii: bezelCornerRadii)
        let mask = CAShapeLayer()

        let bezelMaskPathAnim = CABasicAnimation(keyPath:"path")
        bezelMaskPathAnim.delegate = self
        bezelMaskPathAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        bezelMaskPathAnim.isRemovedOnCompletion = true
        bezelMaskPathAnim.duration = self.transitionDuration(using: transitionContext)
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

    private func alphaAnimation(using transitionContext: UIViewControllerContextTransitioning, transitionType: TransitionType) {
        let maskAlpha = maskView.alpha
        let bezelAlpha = bezelView.alpha
        let duration = self.transitionDuration(using: transitionContext)

        let bezelAlphaAnim = CABasicAnimation(keyPath: "opacity")
        bezelAlphaAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        bezelAlphaAnim.isRemovedOnCompletion = true
        bezelAlphaAnim.duration = duration

        let maskAlphaAnim = CABasicAnimation(keyPath: "opacity")
        maskAlphaAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskAlphaAnim.isRemovedOnCompletion = true
        maskAlphaAnim.duration = duration

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

    // MARK: CAAnimationDelegate
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let mask = anim.value(forKey: "mask") as? CAShapeLayer { mask.removeFromSuperlayer() }
        if let transitionContext = anim.value(forKey: "transitionContext") as? UIViewControllerContextTransitioning {
            transitionContext.completeTransition(flag)
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

