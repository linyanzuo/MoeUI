//
//  CustomDialog.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/9/18.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI
import MoeCommon


class CustomDialog: UIView {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelf()
        setupConstraint()
    }

    deinit {
        MLog("Byebye! form CustomDialog")
    }

    private func setupSelf() {
        backgroundColor = .white
        layer.cornerRadius = 8
    }

    private func setupConstraint() {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: imgView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 24.0),
            NSLayoutConstraint(item: imgView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 32.0),
            NSLayoutConstraint(item: imgView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -32.0),
            NSLayoutConstraint(item: imgView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40),
            NSLayoutConstraint(item: imgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 8),
        ])
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: imgView, attribute: .bottom, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -16.0),
        ])
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        imgView.startAnimating()
    }

    private(set) lazy var imgView: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.animationImages = [UIImage(named: "gen_loding_1")!,
                                   UIImage(named: "gen_loding_2")!,
                                   UIImage(named: "gen_loding_3")!]
        imgView.animationDuration = 0.75
        self.addSubview(imgView)
        return imgView
    }()

    private(set) lazy var label: MoeLabel = {
        let des = Designator()
        des.text("Loading").font(15, weight: .medium)
            .color(0x666666).lines(0).alignment(.center)
        return des.makeLabel(toView: self)
    }()
}
