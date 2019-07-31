//
//  AppearanceVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/7/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI

class AppearanceVC: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var bigLab: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray

        colorView.updateAppearance { (attr) in
            attr.background(color: UIColor.green, cornerRadius: 56)
//            attr.background(color: UIColor.green, cornerRadius: 56, isMaskCornerRadius: true)
        }

        label.updateAppearance { (attr) in
            attr.background(color: UIColor.red, cornerRadius: 8)
        }
//        label.layer.backgroundColor = UIColor.red.cgColor
//        label.layer.cornerRadius = 16
//        label.layer.masksToBounds = true

        bigLab.updateAppearance { (attr) in
            attr.background(color: UIColor.blue, cornerRadius: 16)
        }

//        let byeLab = MoeUI.makeLabel(attributer: nil, toView: self.view) { (attr) in
//            attr.text(" Byebye ")
//            attr.background(color: UIColor.green, cornerRadius: 8)
//        }
//        byeLab.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addConstraints([
//            NSLayoutConstraint(item: byeLab, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
//            NSLayoutConstraint(item: byeLab, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 100),
//        ])
    }

}
