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
        // Appearance Demo
//        CALayer.swizzleLayoutSubviews()

        // SidePanDrawer Demo
        let mainVC = SideMainVC.storyboardInstance()
        let navVC = UINavigationController(rootViewController: mainVC!)
        window = UIWindow(frame: MScreen.bounds)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()

        return true
    }

}
