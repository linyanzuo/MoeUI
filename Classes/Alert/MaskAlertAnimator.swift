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
        case alert
        case sheet
    }

    private let kBezelCornerRadius: CGFloat = 8.0

    // MARK: Object Life Cycle
    var owner: MaskAlertAnimatorProtocol
    var transitionType: TransitionType
    var animationType: AnimationType

    public init(owner: MaskAlertAnimatorProtocol, transitionType: TransitionType, animationType: AnimationType = .sheet) {
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

        if animationType == .sheet {
            animation(containerView: containerView, using: transitionContext, transitionType: .present)
        } else if animationType == .alert {
            alertAnimation(using: transitionContext, transitionType: .present)
        }
    }

    private func animateDismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? MaskAlertAnimatorProtocol,
            let _ = transitionContext.viewController(forKey: .to)
        else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)

        if animationType == .sheet {
            animation(containerView: containerView, using: transitionContext, transitionType: .dismiss)
        } else if animationType == .alert {
            alertAnimation(using: transitionContext, transitionType: .dismiss)
        }
    }

    // MARK: Animation
    private func animation(containerView: UIView, using transitionContext: UIViewControllerContextTransitioning, transitionType: TransitionType) {
        let maskView = owner.maskViewForAnimation()
        let contentView = owner.contentViewForAnimation()
        let duration = self.transitionDuration(using: transitionContext)

        if transitionType == .present {
            let maskViewOriginalAlpha = maskView.alpha
            maskView.alpha = 0.0
            contentView.frame.origin = CGPoint(x: 0, y: containerView.frame.height)

            UIView.animate(withDuration: duration, animations: {
                maskView.alpha = maskViewOriginalAlpha
                contentView.frame.origin = CGPoint(x: 0, y: (containerView.frame.height - contentView.frame.height))
            }) { (isFinish) in
                let isComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(isComplete)
            }
        } else if transitionType == .dismiss {
            UIView.animate(withDuration: duration, animations: {
                maskView.alpha = 0.0
                contentView.frame.origin = CGPoint(x: 0, y: containerView.frame.height + contentView.frame.height)
            }) { (isFinish) in
                let isComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(isComplete)
            }
        }
    }

    private func alertAnimation(using transitionContext: UIViewControllerContextTransitioning, transitionType: TransitionType) {
        let maskView = owner.maskViewForAnimation()
        let maskOpacity = maskView.alpha
        let bezelView = owner.contentViewForAnimation()
        let duration = self.transitionDuration(using: transitionContext)

        let bezelCornerRadii = CGSize(width: kBezelCornerRadius, height: kBezelCornerRadius)
        let sourceRect = CGRect(x: bezelView.bounds.width / 2,
                                y: bezelView.bounds.height / 2,
                                width: kBezelCornerRadius * 2,
                                height: kBezelCornerRadius * 2)
        let sourcePath = UIBezierPath(roundedRect: sourceRect, byRoundingCorners: .allCorners, cornerRadii: bezelCornerRadii)
        let destinPtah = UIBezierPath(roundedRect: bezelView.bounds, byRoundingCorners: .allCorners, cornerRadii: bezelCornerRadii)
        let mask = CAShapeLayer()

        let pathAnimation = CABasicAnimation(keyPath:"path")
        pathAnimation.duration = duration
        pathAnimation.delegate = self
        pathAnimation.isRemovedOnCompletion = true
        pathAnimation.setValue(mask, forKey: "mask")
        pathAnimation.setValue(transitionContext, forKey: "transitionContext")

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = duration
        opacityAnimation.duration = duration
        opacityAnimation.isRemovedOnCompletion = true

        if transitionType == .present {
            pathAnimation.fromValue = sourcePath.cgPath
            pathAnimation.toValue = destinPtah.cgPath
            opacityAnimation.fromValue = 0.0
            opacityAnimation.toValue = maskOpacity
            mask.path = destinPtah.cgPath
        } else if transitionType == .dismiss {
            pathAnimation.fromValue = destinPtah.cgPath
            pathAnimation.toValue = sourcePath.cgPath
            opacityAnimation.fromValue = maskOpacity
            opacityAnimation.toValue = 0.0
            mask.path = sourcePath.cgPath
        }

        maskView.layer.add(opacityAnimation, forKey: "opacityAnimation")
        mask.add(pathAnimation, forKey: "pathAnimation")
        bezelView.layer.mask = mask
    }

    // MARK: CAAnimationDelegate
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let mask = anim.value(forKey: "mask") as? CAShapeLayer,
            let transitionContext = anim.value(forKey: "transitionContext") as? UIViewControllerContextTransitioning
        {
            mask.removeFromSuperlayer()
            transitionContext.completeTransition(flag)
        }
    }
}

