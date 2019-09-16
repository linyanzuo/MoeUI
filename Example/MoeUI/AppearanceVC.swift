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
    @IBOutlet weak var colorView: MoeView!
    @IBOutlet weak var gradientView: MoeView!
    @IBOutlet weak var label: MoeLabel!
    @IBOutlet weak var bigLabel: MoeLabel!
    @IBOutlet weak var bgBtn: MoeButton!
    @IBOutlet weak var imgBtn: MoeButton!
    @IBOutlet weak var imgView: MoeImageView!
    
    class func storyboardInstance() -> AppearanceVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NSStringFromClass(self.classForCoder())) as! AppearanceVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        // 更新 View 的外观示例
        self.updateViewAppearance()

        // 更新 Label 的外观示例
        self.updateLabelAppearance()

        // 更新 Button 的外观示例
        self.updateButtonAppearance()

//        self.view.addSubview(byeLab)
//        byeLab.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addConstraints([
//            NSLayoutConstraint(item: byeLab, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
//            NSLayoutConstraint(item: byeLab, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 100),
//        ])

//        imgView.updateAppearance { (attr) in
//            attr.image(UIImage(named: "Lambert")!).cornerRadius(16)
//            attr.background(color: .clear).border(2, color: .blue).cornerRadius(16)
//                .gradient(startPoint: CGPoint(x: 0, y: 0.5),
//                          endPoint: CGPoint(x: 1.0, y: 0.5),
//                          colors: [.red, .blue],
//                          locations: [0, 1])
//            attr.image(UIImage(named: "Lambert")!, state: .selected)
//            attr.shadow(color: UIColor.red).cornerRadius(16)
//        }

//        imgBtn.updateAppearance { (attr) in
//            attr.backgroundImage(UIImage(named: "Lambert")!, state: .normal).cornerRadius(16)
//            attr.backgroundImage(UIImage(named: "Lambert")!, state: .highlighted).cornerRadius(16)
//            attr.background(color: .white).cornerRadius(16).border(2, color: .blue)
//            attr.text("Normal").color(0x333333)
//            attr.text("Selected", state: .highlighted).color(0x999999)
//            attr.shadow(color: UIColor.red).cornerRadius(16)
//        }
    }

    private func updateViewAppearance() {
        /// `BackgroundAttributer` 用来描述与背景相关的配置, 如背景色, 背景圆角, 背景边框, 渐变背景等
        /// `ShadowAttributer` 用来描述与阴影相关的配置, 如阴影颜色, 阴影圆角, 阴影路径等

        // 覆盖原有的appear配置
        colorView.resetAppearance { (attr) in
            // 蓝色背景, 16号圆角, 带1点像素的红色边框
            attr.background(color: .blue).cornerRadius(16).border(1, color: UIColor.red)
            // 红色阴影, 8号圆角
            attr.shadow(color: UIColor.red).cornerRadius(8)
        }

        // 在原先的appear配置基础上进行修改或增加
        gradientView.updateAppearance { (appear) in
            // 红蓝渐变背景, 16l号圆角
            appear.background(color: .clear).cornerRadius(16)
                .gradient(startPoint: CGPoint(x: 0, y: 0.5),
                          endPoint: CGPoint(x: 1.0, y: 0.5),
                          colors: [.red, .blue],
                          locations: [0, 1])
        }
    }

    private func updateLabelAppearance() {
        // 以闭包的形式重置外观配置
        label.resetAppearance { (appear) in
            // 12号蓝色默认字体, 内容为"更新外观后的文本标签"
            appear.text("更新外观后的文本标签").font(12).color(.blue)
            // 背景透明时, Label的阴影路径与文本一样
            appear.shadow(color: .blue).cornerRadius(16)
        }

        // 创建Appearance实例, 并设置外观配置, 再应用到UI控件上
        let appear = Appearance()
        appear.text(" 18号大字体, 带有背景 ").font(18).color(.white)
        appear.background(color: .gray).cornerRadius(8)
        appear.shadow(color: .blue).cornerRadius(8)
        bigLabel.resetAppearance(appearance: appear)
    }

    private func updateButtonAppearance() {
        bgBtn.updateAppearance { (attr) in
            attr.background(color: .clear).cornerRadius(5)
                .gradient(startPoint: CGPoint(x: 0, y: 0),
                          endPoint: CGPoint(x: 1, y: 1),
                          colors: [.red, .green, .blue],
                          locations: [0.33, 0.66, 1.0])
            attr.text("取消").color(.white).font(20, weight: .bold)
            // 添加响应事件, 支持多事件同时添加, 默认为 touchUpInside
            attr.event(target: self, action: #selector(bgBtnTouchUpInsideAction))
            attr.event(target: self, action: #selector(bgBtnTouchDownAction), for: .touchDown)
        }
    }

    @objc func bgBtnTouchDownAction() {
//        MLog("Touch down")
//        Alerter.showError(text: "Unfortunately, It don't work!", in: self.view)
//        GlobalAlertManager.shared.alert(style: .progress, text: "So bad, It doesn't finish", with: "Progress")
//        Alerter.showGlobalDialog(style: .progress, text: "So bad, It doesn't finish")

        perform(#selector(hide), with: nil, afterDelay: 0.5)
    }

    @objc func bgBtnTouchUpInsideAction() {
//        MLog("Touch up inside")
        bigLabel.updateAppearance { (appear) in
            // nil 不会影响原有的文本
            appear.text(nil).color(.green)
        }

        test()
    }

    var id: AlertIdentifier? = nil
    @objc func test() {
//        HUD.showSuccess(text: "Configuration, It work!")

        Alerter.showDialog(style: .success, text: "Configuration, it work!", in: self.view, with: "Test")
    }

    @objc func hide() {
//        HUD.showToast(text: "Message here!")

//        Alerter.hide(in: self.view, with: "Test")
    }
}
