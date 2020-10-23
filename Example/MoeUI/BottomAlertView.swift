//
//  BottomAlertView.swift
//  MoeUI_Example
//
//  Created by Zed on 2020/10/23.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI


class BottomAlertView: AlertView {
    override var animationType: AlertView.AnimationType {
        return .transformFromBottom(outOffScreen: true)
    }
    
    override func setupContentConstraint(contentView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self)
            maker.height.equalTo(380)
        }
    }
}
