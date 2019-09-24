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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: MScreen.bounds)
        window?.makeKeyAndVisible()

        // Register Appearance Identifier
//        registerAppearance()

//        let usageListVC = UsageListVC(style: .grouped)
//        let navVC = UINavigationController(rootViewController: usageListVC)
//        window?.rootViewController = navVC
//        window?.makeKeyAndVisible()

        // Gradient Demo
//        let gradientVC = GradientVC.storyboardInstance()
//        window?.rootViewController = gradientVC

        // SidePanDrawer Demo
        let mainVC = SideMainVC.storyboardInstance()
        let navVC = UINavigationController(rootViewController: mainVC!)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()

//        // PageMenu
//        let main = PageDemoViewController()
//        let navVC = UINavigationController(rootViewController: main)
//        window?.rootViewController = navVC
//        window?.makeKeyAndVisible()

        return true
    }
}
