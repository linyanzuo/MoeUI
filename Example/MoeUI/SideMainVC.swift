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
    class func storyboardInstance() -> SideMainVC? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NSStringFromClass(self.classForCoder())) as? SideMainVC
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.navigationItem.title = "Main"
        let btn = UIButton(type: .contactAdd)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)

        let pageVC = SidePageVC.storyboardInstance()!
//        let nav = UINavigationController(rootViewController: pageVC)
        drawerEnableEdgePan(pageVC, requireScreenEdge: true)
    }

    @objc private func btnAction() {
        let pageVC = SidePageVC.storyboardInstance()!
//        let nav = UINavigationController(rootViewController: pageVC)
        self.drawerPresentSide(pageVC)
//        self.present(nav, animated: true, completion: nil)
    }
}
