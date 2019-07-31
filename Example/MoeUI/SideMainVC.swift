//
//  SideMainVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/7/31.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI

class SideMainVC: UIViewController, UIViewControllerTransitioningDelegate {
    // UIViewControllerAnimatedTransitioning
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 1.0
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        Animator(configuration: Configuration())
//    }

    let animator = Animator(configuration: Configuration())

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DrawerTransition(configuration: Configuration(), transitionType: .present, animationType: .default)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DrawerTransition(configuration: Configuration(), transitionType: .dismiss, animationType: .default)
    }

    class func storyboardInstance() -> SideMainVC? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NSStringFromClass(self.classForCoder())) as? SideMainVC
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.navigationItem.title = "Main"
        let btn = UIButton(type: .contactAdd)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }

    @objc private func btnAction() {
        print("Hello world")
        let pageVC = SidePageVC.storyboardInstance()!
//        let animator = Animator(configuration: Configuration())
        pageVC.transitioningDelegate = animator
        pageVC.modalPresentationStyle = .custom
        self.present(pageVC, animated: true, completion: nil)
    }

}
