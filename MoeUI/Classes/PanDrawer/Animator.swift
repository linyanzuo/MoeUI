//
//  Animator.swift
//  MoeUI
//
//  Created by Zed on 2019/7/31.
//

import UIKit


public class Animator: NSObject, UIViewControllerTransitioningDelegate {
    // MARK: Object Life Cycle
    
    public var presentInteraction: InteractiveTransition?
    public var dismissInteraction: InteractiveTransition?

    var configuration: Configuration
    var animationType: AnimationType

    public init(configuration: Configuration, animationType: AnimationType = .default) {
        self.configuration = configuration
        self.animationType = animationType
    }

//    deinit {
//        MLog("Animator deinit")
//    }

    // MARK: UIViewControllerTransitioningDelegate
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DrawerTransition(configuration: configuration, transitionType: .present, animationType: animationType)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DrawerTransition(configuration: configuration, transitionType: .dismiss, animationType: animationType)
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard presentInteraction?.isInteracting == true else { return nil}
        return presentInteraction
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard dismissInteraction?.isInteracting == true else { return nil }
        return dismissInteraction
    }
}
