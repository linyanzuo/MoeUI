//
//  UIViewController+SidePanDrawer.swift
//  MoeUI
//
//  Created by Zed on 2019/8/1.
//

import UIKit


extension RuntimeKey {
    static let sidePannerAnimator = MRuntimeKey(for: "SidePannerAnimator")!
}
extension UIViewController {
    @objc public var sidePannerAnimator: Animator? {
        set { objc_setAssociatedObject(self, RuntimeKey.sidePannerAnimator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get { return objc_getAssociatedObject(self, RuntimeKey.sidePannerAnimator) as? Animator }
    }

    public func presentSidePan(_ drawerViewController: UIViewController) {
        var configuration = Configuration()
        configuration.panDirection = PanDirection.fromLeft

        let animator = Animator(configuration: configuration)
        drawerViewController.sidePannerAnimator = animator

        let dismissInteraction = InteractiveTransition(transitionType: .dismiss, configuration: configuration)
        dismissInteraction.sidePageVC = drawerViewController
        animator.dismissInteraction = dismissInteraction

        drawerViewController.transitioningDelegate = animator
        // custom 会导致`dismiss`之后, 控制器都消失, 黑屏
//        pageVC.modalPresentationStyle = .custom
        self.present(drawerViewController, animated: true, completion: nil)
    }

    public func enableSidePanGesturePresent(_ drawerViewController: UIViewController, requireEdge: Bool = true) {
        let presentInteraction = InteractiveTransition(transitionType: .present, configuration: Configuration())
        presentInteraction.enableEdgePan = requireEdge
        presentInteraction.addPanGesture(for: self)
        presentInteraction.didPanClosure = { [weak self] panDirection in
            presentInteraction.configuration.panDirection = panDirection
            self?.presentSidePan(drawerViewController)
        }

        let animator = Animator(configuration: presentInteraction.configuration)
        animator.presentInteraction = presentInteraction

        self.sidePannerAnimator = animator
    }
}
