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
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.animationType = .transformFromBottom(outOffScreen: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupContentConstraint(contentView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self)
            maker.height.equalTo(380)
        }
    }
    
    public func show(in view: UIView) {
        self.frame = view.bounds
        view.addSubview(self)
        self.addAlert(customView: dialog, with: "Progress")
    }
    
    private(set) lazy var dialog: AlertDialog = {
        let dialog = AlertDialog(style: .progress, text: "正在处理")
        return dialog
    }()
}
