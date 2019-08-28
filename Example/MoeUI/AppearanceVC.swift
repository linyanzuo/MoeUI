//
//  AppearanceVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/7/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI

extension RuntimeKey {
    static let test = MRuntimeKey(for: "test")!
}

class AppearanceVC: UIViewController, Runtime {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var bigLab: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bgBtn: UIButton!
    @IBOutlet weak var imgBtn: UIButton!
    
    class func storyboardInstance() -> AppearanceVC? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NSStringFromClass(self.classForCoder())) as? AppearanceVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        colorView.updateAppearance { (attr) in
//            attr.background(color: UIColor.green).cornerRadius(16).border(1, color: UIColor.red)
//            attr.shadow(color: UIColor.red).cornerRadius(16)
            attr.background(color: UIColor.green).cornerRadius(16)
                .gradient(startPoint: CGPoint(x: 0, y: 0.5),
                          endPoint: CGPoint(x: 1.0, y: 0.5),
                          colors: [.red, .blue],
                          locations: [0, 1])
        }

        setAssociatedRetainObject(object: colorView, for: RuntimeKey.test)
        MLog(getAssociatedObject(for: RuntimeKey.test))

        label.updateAppearance { (attr) in
            attr.background(color: UIColor.red).cornerRadius(4).border(1)
        }
//        label.layer.backgroundColor = UIColor.red.cgColor
//        label.layer.cornerRadius = 16
//        label.layer.masksToBounds = true

        bigLab.updateAppearance { (attr) in
            attr.text(" bigLabel ")
            attr.background(color: UIColor.green).cornerRadius(16)
                .gradient(startPoint: CGPoint(x: 0, y: 0.5),
                          endPoint: CGPoint(x: 1.0, y: 0.5),
                          colors: [UIColor(rgb: 0x048DF7), UIColor(rgb: 0x5F4AF0)],
                          locations: [0, 1])
//            attr.shadow(color: UIColor.red).cornerRadius(16)
        }

//        let byeLab = MoeUI.makeLabel(appearance: nil, toView: self.view) { (attr) in
//            if #available(iOS 11.0, *) { attr.text("Byebye").firstLineIndent(4).color(UIColor.red).font(18) }
//            attr.background(color: UIColor.green).cornerRadius(8)
//        }

//        let appearance = Appearance()
//        appearance.text("Bye bye!!!").color(.blue)
//        appearance.background(color: .yellow).cornerRadius(8)
//        let byeLab = UILabel(appearance: appearance)

//        let byeLab = UILabel { (attr) in
//            attr.text("Byebye").color(.red)
//            attr.background(color: UIColor.green).cornerRadius(8)
//        }
        let byeLab = MoeUI.makeLabel(with: .smallLabel)!

        self.view.addSubview(byeLab)
        byeLab.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: byeLab, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: byeLab, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 100),
        ])

        imgView.updateAppearance { (attr) in
//            attr.image(UIImage(named: "Lambert")!).cornerRadius(16)
            attr.background(color: .clear).border(2, color: .blue).cornerRadius(16)
                .gradient(startPoint: CGPoint(x: 0, y: 0.5),
                          endPoint: CGPoint(x: 1.0, y: 0.5),
                          colors: [UIColor(rgb: 0x048DF7), UIColor(rgb: 0x5F4AF0)],
                          locations: [0, 1])
//            attr.image(UIImage(named: "Lambert")!, state: .selected)
//            attr.shadow(color: UIColor.red).cornerRadius(16)
        }

        bgBtn.updateAppearance { (attr) in
//            attr.image(UIImage(named: "color-icon")!).cornerRadius(16)
//            attr.background(color: UIColor.purple).cornerRadius(16).border(2, color: .blue)
//            attr.shadow(color: UIColor.red).cornerRadius(16)
            attr.background(color: .purple).cornerRadius(8)
                .gradient(startPoint: CGPoint(x: 0, y: 0.5),
                          endPoint: CGPoint(x: 1.0, y: 0.5),
                          colors: [.red, .blue],
                          locations: [0, 1])
            attr.text("Button").color(.black)
        }
        bgBtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        imgBtn.updateAppearance { (attr) in
            attr.backgroundImage(UIImage(named: "Lambert")!, state: .normal).cornerRadius(16)
            attr.backgroundImage(UIImage(named: "Lambert")!, state: .highlighted).cornerRadius(16)
            attr.background(color: .white).cornerRadius(16).border(2, color: .blue)
            attr.text("Normal").color(0x333333)
            attr.text("Selected", state: .highlighted).color(0x999999)
            attr.shadow(color: UIColor.red).cornerRadius(16)
        }
    }

    @objc func btnAction() {
        MoeUI.alert()
//        MoeUI.sheet()
    }
}
