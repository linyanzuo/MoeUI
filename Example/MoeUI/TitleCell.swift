//
//  TitleCell.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/9/18.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI


open class TitleCell: TableViewCell {
    
    open override func setupSubview() {
        selectionStyle = .none
    }
    
    open override func setupConstraint() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -16.0)
        ])
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        separator.frame = CGRect(x: 16, y: self.frame.height - 1, width: self.frame.width - 16 * 2, height: 1)
    }

    // MARK: Getter & Setter
    private(set) lazy var titleLabel: UILabel = {
        let des = Designator()
        des.text(nil).color(UIColor(rgb: 0x4C86B1)).font(15)
        return des.makeLabel(toView: self)
    }()

    private(set) lazy var separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(rgb: 0xf0f0f0).cgColor
        self.layer.addSublayer(layer)
        return layer
    }()
}
