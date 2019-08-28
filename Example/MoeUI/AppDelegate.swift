//
//  AppDelegate.swift
//  MoeUI
//
//  Created by linyanzuo1222@gmail.com on 07/23/2019.
//  Copyright (c) 2019 linyanzuo1222@gmail.com. All rights reserved.
//

import UIKit
import MoeUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: MScreen.bounds)
        window?.makeKeyAndVisible()

        // Gradient Demo
//        let gradientVC = GradientVC.storyboardInstance()
//        window?.rootViewController = gradientVC

        // Appearance Demo
        CALayer.swizzleLayoutSubviews()
        UIView.swizzleLayoutSubviews()
//        UIImageView.swizzleLayoutSubviews()
//        UIButton.swizzleLayoutSubviews()

        registerAppearance()

        let appearanceVC = AppearanceVC.storyboardInstance()!
        let navVC = UINavigationController(rootViewController: appearanceVC)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()

        // SidePanDrawer Demo
//        let mainVC = SideMainVC.storyboardInstance()
//        let navVC = UINavigationController(rootViewController: mainVC!)
//        window?.rootViewController = navVC
//        window?.makeKeyAndVisible()

//        // PageMenu
//        let main = PageDemoViewController()
//        let navVC = UINavigationController(rootViewController: main)
//        window?.rootViewController = navVC
//        window?.makeKeyAndVisible()

        return true
    }

    func registerAppearance() {
        MoeUI.register(identifier: .smallLabel) { (attr) in
            attr.text("Bye bye!!!").color(.blue)
            attr.background(color: .yellow).cornerRadius(8)
        }
    }
}


extension AppearanceIdentifier {
    static let normalLabel = AppearanceIdentifier(rawValue: 0)
    static let hintLabel = AppearanceIdentifier(rawValue: 1)
    static let smallLabel = AppearanceIdentifier(rawValue: 2)
}
