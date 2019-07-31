//
//  Animator.swift
//  MoeUI
//
//  Created by Zed on 2019/7/31.
//

import UIKit
import MoeUI


public class Animator: NSObject, UIViewControllerTransitioningDelegate {
    // MARK: Object Life Cycle
    var configuration: Configuration
    var animationType: AnimationType

    public init(configuration: Configuration, animationType: AnimationType = .default) {
        self.configuration = configuration
        self.animationType = animationType
    }

    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DrawerTransition(configuration: configuration, transitionType: .present, animationType: animationType)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DrawerTransition(configuration: configuration, transitionType: .dismiss, animationType: animationType)
    }
}
