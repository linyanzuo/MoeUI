//
//  AppearanceVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/7/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI


class AppearanceVC: UIViewController, Runtime {
    @IBOutlet weak var label: MoeLabel!
    @IBOutlet weak var bigLab: MoeLabel!
    @IBOutlet weak var colorView: MoeView!
    @IBOutlet weak var imgView: MoeImageView!
    @IBOutlet weak var bgBtn: MoeButton!
    @IBOutlet weak var imgBtn: MoeButton!
    
    class func storyboardInstance() -> AppearanceVC? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NSStringFromClass(self.classForCoder())) as? AppearanceVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        colorView.updateAppearance { (attr) in
            attr.shadow(color: UIColor.red).cornerRadius(16)
            attr.background(color: UIColor.green).cornerRadius(16).border(1, color: UIColor.red)
                .gradient(startPoint: CGPoint(x: 0, y: 0.5),
                          endPoint: CGPoint(x: 1.0, y: 0.5),
                          colors: [.red, .blue],
                          locations: [0, 1])
        }

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
            attr.shadow(color: UIColor.red).cornerRadius(16)
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
            attr.image(UIImage(named: "Lambert")!).cornerRadius(16)
            attr.background(color: .clear).border(2, color: .blue).cornerRadius(16)
//                .gradient(startPoint: CGPoint(x: 0, y: 0.5),
//                          endPoint: CGPoint(x: 1.0, y: 0.5),
//                          colors: [.red, .blue],
//                          locations: [0, 1])
//            attr.image(UIImage(named: "Lambert")!, state: .selected)
//            attr.shadow(color: UIColor.red).cornerRadius(16)
        }

        bgBtn.updateAppearance { (attr) in
//            attr.image(UIImage(named: "color-icon")!).cornerRadius(16)
//            attr.shadow(color: UIColor.red).cornerRadius(16)
            attr.background(color: UIColor(rgb: 0xF43431)).cornerRadius(5)
                .gradient(startPoint: CGPoint(x: 0, y: 0),
                          endPoint: CGPoint(x: 1, y: 1),
                          colors: [UIColor(rgb: 0x048DF7), UIColor(rgb: 0x5F4AF0)],
                          locations: [0.0, 1.0])
            attr.text("取消").color(.white).font(18, weight: .bold)
            attr.event(target: self, action: #selector(btnAction))
            attr.event(target: self, action: #selector(logAction), for: .touchDown)
        }
//        bgBtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
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
        MLog("Btn Action")

//        let dialog = AlertDialog(style: .progress, text: "Hello word")
//        self.view.addSubview(dialog)
//        dialog.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addConstraints([
//            NSLayoutConstraint(item: dialog, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
//            NSLayoutConstraint(item: dialog, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0),
//            NSLayoutConstraint(item: dialog, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200.0),
//            NSLayoutConstraint(item: dialog, attribute: .height, relatedBy: .equal, toItem: nil, attribute: . notAnAttribute, multiplier: 1.0, constant: 160.0)
//        ])

//        let alertVC = AlertController(style: .success, text: "Congratulation, It work!")
//        alertVC.view.backgroundColor = .clear
//        self.present(alertVC, animated: true, completion: nil)

        GlobalAlertManager.shared.alert(style: .success, text: "Configuration, It work!", with: "Success")
        GlobalAlertManager.shared.alert(style: .fail, text: "Unfortunately, It doesn't work!", with: "Fail")
        GlobalAlertManager.shared.alert(style: .progress, text: "So bad, It doesn't finish", with: "Progress")

        perform(#selector(test), with: nil, afterDelay: 1.0)
    }

    @objc func logAction() {
        MLog("Touch Log")
    }

    @objc func test() {
        GlobalAlertManager.shared.hide(with: "Fail")
    }
}
