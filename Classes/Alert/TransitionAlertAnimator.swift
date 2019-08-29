//
//  SheetAnimator.swift
//  MoeUI
//
//  Created by Zed on 2019/8/17.
//

import UIKit


public protocol SheetAnimatorProtocol where Self: UIViewController {
    func contentViewForAnimation() -> UIView
    func maskViewForAnimation() -> UIView
}


/// Sheet Transition Animation Performer
public class AlertAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    public enum TransitionType {
        case present
        case dismiss
    }

    public enum AnimationType {
        case alert
        case sheet
    }

    let DEFAULT_SIZE = CGFloat(32)

    // MARK: Object Life Cycle
    var owner: SheetAnimatorProtocol
    var transitionType: TransitionType
    var animationType: AnimationType

    public init(owner: SheetAnimatorProtocol, transitionType: TransitionType, animationType: AnimationType = .sheet) {
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
            let toVC = transitionContext.viewController(forKey: .to) as? SheetAnimatorProtocol
        else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        toVC.view.layoutIfNeeded()

        if animationType == .sheet {
            sheetAnimation(containerView: containerView, using: transitionContext, transitionType: .present)
        } else if animationType == .alert {
            extendOutAnimation(using: transitionContext, transitionType: .present)
        }
    }

    private func animateDismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? SheetAnimatorProtocol,
            let _ = transitionContext.viewController(forKey: .to)
        else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)

        if animationType == .sheet {
            sheetAnimation(containerView: containerView, using: transitionContext, transitionType: .dismiss)
        } else if animationType == .alert {
            extendOutAnimation(using: transitionContext, transitionType: .dismiss)
        }
    }

    // MARK: Animation
    private func sheetAnimation(containerView: UIView, using transitionContext: UIViewControllerContextTransitioning, transitionType: TransitionType) {
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

    private func extendOutAnimation(using transitionContext: UIViewControllerContextTransitioning, transitionType: TransitionType) {
        let maskView = owner.maskViewForAnimation()
        let contentView = owner.contentViewForAnimation()
        let duration = self.transitionDuration(using: transitionContext)
        let defaultSource = CGRect(x: (MScreen.width - DEFAULT_SIZE) / 2,
                                   y: (MScreen.height - DEFAULT_SIZE) / 2,
                                   width: DEFAULT_SIZE,
                                   height: DEFAULT_SIZE)

        if transitionType == .present {
            let maskViewOriginalAlpha = maskView.alpha
            maskView.alpha = 0.0
            let contentViewOriginalAlpha = contentView.alpha
            contentView.alpha = 0.0
            let contentViewOriginalFrame = contentView.frame
            contentView.frame = defaultSource

            UIView.animate(withDuration: duration, animations: {
                maskView.alpha = maskViewOriginalAlpha
                contentView.frame = contentViewOriginalFrame
                contentView.alpha = contentViewOriginalAlpha
            }) { (isFinish) in
                let isComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(isComplete)
            }
        } else if transitionType == .dismiss {
            UIView.animate(withDuration: duration, animations: {
                maskView.alpha = 0.0
                contentView.frame = defaultSource
                contentView.alpha = 0.0
            }) { (isFinish) in
                let isComplete = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(isComplete)
            }
        }
    }
}

