//
//  Alert.swift
//  MoeUI
//
//  Created by Zed on 2019/8/29.
//

import UIKit


final class AlertWindow: UIWindow {
    static let shared = AlertWindow()

    // MARK: Object Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private init(){
        super.init(frame: UIScreen.main.bounds)
        setupSelf()
    }

    // MARK: Private Method
    private func setupSelf() {
        windowLevel = UIWindow.Level.statusBar + 1
        isHidden = true
    }
}
