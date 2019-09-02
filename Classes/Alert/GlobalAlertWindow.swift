//
//  GlobalAlertWindow.swift
//  MoeUI
//
//  Created by Zed on 2019/8/30.
//

import UIKit


final class GlobalAlertWindow: UIWindow {
    static let shared = GlobalAlertWindow()
    internal var completionHandler: (() -> Void)?

    // MARK: Object Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private init(){
        super.init(frame: UIScreen.main.bounds)
        setupSelf()
        setupSubviews()
    }

    // MARK: Private Method
    private func setupSelf() {
        windowLevel = UIWindow.Level.statusBar + 1
        backgroundColor = .clear
        isHidden = true
    }

    private func setupSubviews() {
        maskBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: maskBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ])
    }

    // MARK: Event Response
    @objc func maskTapAction(_ sender: UIButton) {
        completionHandler?()
    }

    private(set) lazy var maskBtn: UIButton = {
        let appear = Appearance()
        appear.alpha(0.6).background(color: .black)
        appear.event(target: self, action: #selector(maskTapAction(_:)))
        return MoeUI.makeButton(toView: self, with: appear)
    }()
}
