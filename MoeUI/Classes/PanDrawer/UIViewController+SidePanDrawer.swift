//
//  UIViewController+SidePanDrawer.swift
//  MoeUI
//
//  Created by Zed on 2019/8/1.
//

import UIKit
import MoeCommon


struct RuntimeKey {
    static let sidePannerAnimator = runtimeKey(for: "SidePannerAnimator")!
}
extension UIViewController: Runtime {
    @objc public var sidePannerAnimator: Animator? {
        set { setAssociatedRetainObject(object: newValue,
                                        for: RuntimeKey.sidePannerAnimator) }
        get { return getAssociatedObject(for: RuntimeKey.sidePannerAnimator) as? Animator }
    }

    public func drawerEnableEdgePan(_ drawerViewController: UIViewController, requireScreenEdge: Bool = true, configuration: Configuration = Configuration()) {

        let presentInteraction = InteractiveTransition(transitionType: .present, configuration: configuration)
        presentInteraction.enableEdgePan = requireScreenEdge
        presentInteraction.addPanGesture(for: self)
        presentInteraction.didPanClosure = { [weak self] panDirection in
            presentInteraction.configuration.panDirection = panDirection
            self?.drawerPresentSide(drawerViewController, configuration: configuration)
        }

        let animator = Animator(configuration: configuration)
        animator.presentInteraction = presentInteraction
        self.sidePannerAnimator = animator
    }

    public func drawerPresentSide(_ drawerViewController: UIViewController, configuration: Configuration = Configuration()) {
        var animator = self.sidePannerAnimator
        if animator == nil {
            animator = Animator(configuration: configuration)
        }
        drawerViewController.sidePannerAnimator = animator

        let dismissInteraction = InteractiveTransition(transitionType: .dismiss, configuration: configuration)
        dismissInteraction.sidePageVC = drawerViewController
        animator!.dismissInteraction = dismissInteraction

        drawerViewController.transitioningDelegate = animator
        drawerViewController.modalPresentationStyle = .fullScreen
        self.present(drawerViewController, animated: true, completion: nil)
    }

    public func drawerPush(_ viewController: UIViewController) {
        let animator = self.transitioningDelegate as? Animator
        var transitionType = CATransitionType.push

        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        guard rootVC != nil else { return }

        var navVC: UINavigationController? = nil
        if let tabbarVC = rootVC as? UITabBarController,
            let tabbarItemNavVC = tabbarVC.selectedViewController as? UINavigationController
        {
            navVC = tabbarItemNavVC
        } else if let rootNavVC = rootVC as? UINavigationController {
            if animator?.animationType == .default { transitionType = CATransitionType.fade }
            navVC = rootNavVC
        }
        guard navVC != nil else { return }

        // 为`fromVC`的push过程添加渐变过渡效果
        if animator != nil {
            let transition = CATransition()
            transition.duration = 0.10
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            transition.type = transitionType
            transition.subtype = animator?.configuration.panDirection == .fromRight ?
                CATransitionSubtype.fromRight : CATransitionSubtype.fromLeft
            navVC!.view.layer.add(transition, forKey: nil)
        }

        self.dismiss(animated: true, completion: nil)
        navVC!.pushViewController(viewController, animated: false)
    }
}
