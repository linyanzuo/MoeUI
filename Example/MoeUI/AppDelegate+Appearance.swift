//
//  AppDelegate+Appearance.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/9/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import MoeUI


extension AppDelegate {
    func registerAppearance() {
        MoeUI.register(identifier: .settingTitle) { (appear) in
            appear.text(nil).color(UIColor(rgb: 0x02828B)).font(15, weight: .medium)
        }
        MoeUI.register(identifier: .settingDetail) { (appear) in
            appear.text(nil).color(UIColor(rgb: 0x963847)).font(14, weight: .regular)
        }
    }
}
