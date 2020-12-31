//
//  AppDelegate.swift
//  MoeUI
//
//  Created by linyanzuo1222@gmail.com on 07/23/2019.
//  Copyright (c) 2019 linyanzuo1222@gmail.com. All rights reserved.
//

import UIKit
import MoeUI
import MoeCommon


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: MScreen.bounds)

        // 侧滑案例
        let mainVC = UsageListVC(style: .grouped)
        let navVC = UINavigationController(rootViewController: mainVC)

        // 分页菜单案例
//        let pageVC = PageDemoViewController()
//        let navVC = UINavigationController(rootViewController: pageVC)
        
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()

        return true
    }
}
