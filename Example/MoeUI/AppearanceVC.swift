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
    @IBOutlet weak var insertBtn: MoeButton!
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

        // 更新 ImageView 的外观示例
        self.updateImageViewAppearance()
    }

    // MARK: Add appearance control methods
    @objc func addAppearanceControl() {
        MLog("it work!")
        // 添加新 Label 示例
        let newLabel = MoeUI.makeLabel(toView: self.view) { (appear) in
            appear.text("New Label").font(18).color(.orange)
        }

        let newImgView = MoeUI.makeImageView(toView: self.view) { (appear) in
            appear.image(UIImage(named: "Lambert")!).cornerRadius(16)
            appear.background(color: .blue)
            appear.shadow(color: UIColor.red)
        }

        // 添加约束
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: newLabel, attribute: .top, relatedBy: .equal, toItem: bgBtn, attribute: .bottom, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: newLabel, attribute: .left, relatedBy: .equal, toItem: bgBtn, attribute: .left, multiplier: 1.0, constant: 16.0)
        ])
        newImgView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: newImgView, attribute: .top, relatedBy: .equal, toItem: newLabel, attribute: .bottom, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: newImgView, attribute: .left, relatedBy: .equal, toItem: newLabel, attribute: .left, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: newImgView, attribute: .width, relatedBy: .equal, toItem:  nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 128.0),
            NSLayoutConstraint(item: newImgView, attribute: .height, relatedBy: .equal, toItem:  nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 128.0)
        ])
    }

    // MARK: Update Appearance Methods
    private func updateViewAppearance() {
        /// `BackgroundAttributer` 用来描述与背景相关的配置, 如背景色, 背景圆角, 背景边框, 渐变背景等
        /// `ShadowAttributer` 用来描述与阴影相关的配置, 如阴影颜色, 阴影圆角, 阴影路径等

        // 覆盖原有的appear配置
        colorView.resetAppearance { (attr) in
            // 蓝色背景, 16号圆角, 带1点像素的红色边框
            attr.background(color: .blue).cornerRadius(16).border(1, color: UIColor.red)
            // 红色阴影, 8号圆角
            attr.shadow(color: UIColor.green).cornerRadius(8)
        }

        // 在原先的appear配置基础上进行修改或增加
        gradientView.updateAppearance { (appear) in
            // 红蓝渐变背景, 16l号圆角
            appear.background(color: .clear).cornerRadius(16)
                .gradient(startPoint: CGPoint(x: 0, y: 0.5),
                          endPoint: CGPoint(x: 1.0, y: 0.5),
                          colors: [.red, .blue],
                          locations: [0, 1])
            appear.shadow(color: UIColor.yellow).cornerRadius(8)
        }
    }

    private func updateLabelAppearance() {
        // 以闭包的形式重置外观配置
        label.resetAppearance { (appear) in
            // 12号蓝色默认字体, 内容为"更新外观后的文本标签"
            appear.text("更新外观后的文本标签").font(12).color(.blue)
            // 背景透明时, Label的阴影路径与文本一致
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
        bgBtn.updateAppearance { (appear) in
            appear.background(color: .clear).cornerRadius(5)
                .gradient(startPoint: CGPoint(x: 0, y: 0),
                          endPoint: CGPoint(x: 1, y: 1),
                          colors: [.red, .green, .blue],
                          locations: [0.33, 0.66, 1.0])
            appear.text("取消").color(.white).font(20, weight: .bold)
            // 添加响应事件, 支持多事件同时添加, 默认为 touchUpInside
            appear.event(target: self, action: #selector(bgBtnTouchUpInsideAction))
            appear.event(target: self, action: #selector(bgBtnTouchDownAction), for: .touchDown)
        }

        insertBtn.updateAppearance { (appear) in
            appear.background(color: .purple).cornerRadius(5)
            appear.event(target: self, action: #selector(addAppearanceControl))
            appear.text(nil).color(.white)
        }
    }

    private func updateImageViewAppearance() {
        imgView.updateAppearance { (appear) in
            appear.image(UIImage(named: "Lambert")!).cornerRadius(16)
            appear.shadow(color: UIColor.red).cornerRadius(16)
        }
    }

    // MARK: Event response methods
    @objc func bgBtnTouchDownAction() {
        MLog("Touch down")
    }

    @objc func bgBtnTouchUpInsideAction() {
        MLog("Touch up inside")
        bigLabel.updateAppearance { (appear) in
            // nil 不会影响原有的文本
            appear.text(nil).color(.green)
            appear.background(color: .orange)
        }
    }
}
