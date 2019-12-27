//
//  DrawerTransition.swift
//  MoeUI
//
//  Created by Zed on 2019/7/31.
//
//  抽屉动画效果

import UIKit
import MoeCommon


public enum AnimationType {
    case `default`
    case mask
}


public enum TransitionType {
    case present
    case dismiss
}


class DrawerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: Object Life Cycle
    var configuration: Configuration
    var transitionType: TransitionType
    var animationType: AnimationType
    var animationDelayTime: TimeInterval {
        get {
            if MDevice.phoneVersion >= 11.0 { return 0.03 }
            return 0.0
        }
    }

    public init(configuration: Configuration, transitionType: TransitionType, animationType: AnimationType) {
        self.configuration = configuration
        self.transitionType = transitionType
        self.animationType = animationType
    }

    // MARK: UIViewControllerAnimatedTransitioning
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if transitionType == .present { return configuration.presentAnimationDuration }
        return configuration.dismissAnimationDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case .present:
            if animationType == .default { animateDefaultPresentTransition(using: transitionContext) }
            if animationType == .mask { animateMaskPresentTransition(using: transitionContext) }
        case .dismiss:
            animateDismissTransition(using: transitionContext)
        }
    }

    // MARK: Private Method
    private func animateDefaultPresentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else { return }

        let maskView = MaskView.shared
        maskView.frame = fromVC.view.bounds
        fromVC.view.addSubview(maskView)

        let containerView = transitionContext.containerView
        var imageView: UIImageView?
        if configuration.backgroundImage != nil {
            imageView = UIImageView(frame: containerView.bounds)
            imageView!.image = configuration.backgroundImage
            imageView!.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            containerView.addSubview(imageView!)
        }

        // --- 动画效果计算; toTransform初始状态就显示一半内容, 执行动画时再移动一半内容的距离 ---
        let sidePageWidth = configuration.distancePercent * MScreen.width
        let toViewX = configuration.panDirection == .fromLeft ?
            (-sidePageWidth / 2) : (MScreen.width - sidePageWidth / 2)
        toVC.view.frame = CGRect(x: toViewX, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)

        let multiple: CGFloat = configuration.panDirection == .fromLeft ? 1.0 : -1.0
        let translationX = sidePageWidth - (MScreen.width * (1 - configuration.viewScaleY) / 2)
        let scale = CGAffineTransform(scaleX: configuration.viewScaleY, y: configuration.viewScaleY)
        let translation = CGAffineTransform(translationX: multiple * translationX, y: 0)
        let fromTransform = scale.concatenating(translation)
        var toTransform = CGAffineTransform(translationX: multiple * sidePageWidth / 2, y: 0)
        if configuration.panDirection == .fromRight {
            toTransform = CGAffineTransform(translationX: multiple * (sidePageWidth - (containerView.frame.width - toViewX)), y: 0)
        }

        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: animationDelayTime, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                fromVC.view.transform = fromTransform
                toVC.view.transform = toTransform
                imageView?.transform = CGAffineTransform.identity
                maskView.alpha = self.configuration.maskViewAlpha
            })
        }) { (finished) in
            if transitionContext.transitionWasCancelled == true {
                imageView?.removeFromSuperview()
                maskView.releaseShared()
                transitionContext.completeTransition(false)
            } else {
//                // 针对导航控制器特殊效果的处理
//                if toVC.isKind(of: UINavigationController.classForCoder()) == false {
//                    maskView.subviewsOfToVCRootView = fromVC.view.subviews
//                }
                transitionContext.completeTransition(true)
                containerView.addSubview(fromVC.view)
            }
        }
    }

    private func animateMaskPresentTransition(using transitionContext: UIViewControllerContextTransitioning) {
    }

    private func animateDismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else { return }

        let maskView = MaskView.shared
//        if toVC.isKind(of: UINavigationController.classForCoder()) == false {
//            for subview in toVC.view.subviews {
//                if maskView.subviewsOfToVCRootView?.contains(subview) == false { subview.removeFromSuperview() }
//            }
//        }

        let containerView = transitionContext.containerView
        var bgImgView: UIImageView?
        if containerView.subviews.first?.isKind(of: UIImageView.classForCoder()) == true {
            bgImgView = containerView.subviews.first as? UIImageView
        }

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animateKeyframes(withDuration: duration, delay: animationDelayTime, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0, animations: {
                toVC.view.transform = CGAffineTransform.identity
                fromVC.view.transform = CGAffineTransform.identity
                maskView.alpha = 0.0
                bgImgView?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            })
        }) { (finished) in
            if transitionContext.transitionWasCancelled == false {
//                maskView.subviewsOfToVCRootView = nil
                maskView.releaseShared()
                bgImgView?.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
