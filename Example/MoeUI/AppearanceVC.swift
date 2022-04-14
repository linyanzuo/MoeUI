//
//  AppearanceVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/7/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI
import MoeCommon


class AppearanceVC: UIViewController {
    @IBOutlet weak var colorView: MoeView!
    @IBOutlet weak var gradientView: MoeView!
    @IBOutlet weak var imgView: MoeImageView!
    
    @IBOutlet weak var leftLabel: MoeLabel!
    @IBOutlet weak var rightLabel: MoeLabel!
    
    @IBOutlet weak var leftBtn: MoeButton!
    @IBOutlet weak var rightBtn: MoeButton!
    
    class func storyboardInstance() -> AppearanceVC? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NSStringFromClass(self.classForCoder())) as? AppearanceVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        // 更新 View 的外观示例
//        self.updateViewAppearance()

        // 更新 Label 的外观示例
//        self.updateLabelAppearance()

        // 更新 Button 的外观示例
//        self.updateButtonAppearance()

        // 更新 ImageView 的外观示例
//        self.updateImageViewAppearance()
    }
    
    // MARK: Designator 用法示例
    
    /// 一个`Designator（设计器）`能作用于多种不同类型的控件，完成相应效果的展示
    /// 不同控件所支持的样式不同，因此同一个设计器应用到不到控件上，可能有不同效果
    @IBAction func designatorDemo() {
        // 创建`Designator`，配置橙色圆角背景、蓝边框、绿色阴影
        let designator = Designator()
        designator.background(.orange).cornerRadius(8).border(2, color: .blue)
        designator.shadow(.green).cornerRadius(8)
        
        // `Designator`能对适配的控件进行赋值，实现指定效果
        // 由于控件性质不同，并非所有的赋值都能生效。如`UIView`不能配置文本
        designator.applyValuator(toView: self.colorView)
        designator.applyValuator(toView: self.imgView)
        designator.applyValuator(toView: self.leftLabel)
        designator.applyValuator(toView: self.rightBtn)
    }
    
    /// `Designator`内包含了多个`Valuator`，每个`Valuator`负责各自样式属性的赋值操作
    /// 可根据需要，自由组装不同的赋值器至设计器中
    @IBAction func designatorDemo2() {
        // 创建背景赋值器及阴影赋值器，并配置相关参数
        let background = BackgroundValuator(color: .blue).cornerRadius(16)
            .gradient(startPoint: CGPoint(x: 0, y: 0.5),
                      endPoint: CGPoint(x: 1.0, y: 0.5),
                      colors: [.red, .blue],
                      locations: [0, 1])
        let shadow = ShadowValuator(color: .blue).cornerRadius(12)
        let text = TextValuator(text: "Hello world").font(15)
            .color(.white).alignment(.center)
        
        /// 可根据需要，自由组装不同的赋值器至设计器中
        Designator(valuators: [background, shadow])
            .applyValuator(toViews: [self.gradientView])
        
        /// Label并不支持直接使用渐变图层。因此渐变背景的配置无效
        Designator(valuators: [background, text])
            .applyValuator(toViews: [self.rightLabel, self.leftBtn])
    }

    /// `Designator`提供了快速创建可赋值控件的方法
    @IBAction func designatorDemo3(_ sender: Any) {
        let x = CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width - 100)))
        let y = CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.height - 100)))
        
        let newBtn = Designator.makeButton(toView: view) { (des) in
            des.background(.random).cornerRadius(8)
            des.text("这是个按钮").font(14).color(.random)
            des.event(.touchUpInside, for: self, action: #selector(self.insideAction(_:)))
            des.event(.touchUpOutside, for: self, action: #selector(self.outsideAction(_:)))
            des.general.frame(CGRect(x: x, y: y, width: 100, height: 100))
        }
        MLog(newBtn)
    }
    
    /// 每个视图上都保存了属性自己的`Designator`实例，可随时更新样式配置
    @IBAction func designatorDemo4(_ sender: Any) {
        imgView.updateDesign { (des) in
//            des.image(UIImage(named: "Lambert")!).cornerRadius(16)
            des.image(UIImage(named: "Lambert")!).maskCornerRadius(32, maskColor: .white)
        }
        let dtor = Designator()
        dtor.background().color(.green)
        colorView.updateDesignator(dtor)
    }
    
    @objc func outsideAction(_ sender: Any) {
        print("Touch up outside")
    }
    
    @objc func insideAction(_ sender: Any) {
        print("Touch up inside")
    }
    
    // MARK: Add appearance control methods
//    @objc func addAppearanceControl() {
//        MLog("it work!")
//        // 添加新 Label 示例
//        let newLabel = Designator.makeLabel(toView: self.view) { (des) in
//            des.text("New Label").font(18).color(.orange)
//        }
//
//        let newImgView = Designator.makeImageView(toView: self.view) { (designator) in
//            designator.image(UIImage(named: "Lambert")!).cornerRadius(16)
//            designator.background(.blue)
//            designator.shadow(UIColor.red)
//        }
//
//        // 添加约束
//        newLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addConstraints([
//            NSLayoutConstraint(item: newLabel, attribute: .top, relatedBy: .equal, toItem: bgBtn, attribute: .bottom, multiplier: 1.0, constant: 16.0),
//            NSLayoutConstraint(item: newLabel, attribute: .left, relatedBy: .equal, toItem: bgBtn, attribute: .left, multiplier: 1.0, constant: 16.0)
//        ])
//        newImgView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addConstraints([
//            NSLayoutConstraint(item: newImgView, attribute: .top, relatedBy: .equal, toItem: newLabel, attribute: .bottom, multiplier: 1.0, constant: 16.0),
//            NSLayoutConstraint(item: newImgView, attribute: .left, relatedBy: .equal, toItem: newLabel, attribute: .left, multiplier: 1.0, constant: 16.0),
//            NSLayoutConstraint(item: newImgView, attribute: .width, relatedBy: .equal, toItem:  nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 128.0),
//            NSLayoutConstraint(item: newImgView, attribute: .height, relatedBy: .equal, toItem:  nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 128.0)
//        ])
//    }

    // MARK: Update Appearance Methods
//    private func updateViewAppearance() {
//        /// `BackgroundAttributer` 用来描述与背景相关的配置, 如背景色, 背景圆角, 背景边框, 渐变背景等
//        /// `ShadowAttributer` 用来描述与阴影相关的配置, 如阴影颜色, 阴影圆角, 阴影路径等
//
//        // 覆盖原有的appear配置
//        colorView.resetDesign { (des) in
//            // 蓝色背景, 16号圆角, 带1点像素的红色边框
//            des.background(.blue).cornerRadius(16).border(1, color: UIColor.red)
//            // 红色阴影, 8号圆角
//            des.shadow(UIColor.green).cornerRadius(8)
//        }
//
//        // 在原先的appear配置基础上进行修改或增加
//        gradientView.updateDesign { (designator) in
//            // 红蓝渐变背景, 16l号圆角
//            designator.background(.clear).cornerRadius(16)
//                .gradient(startPoint: CGPoint(x: 0, y: 0.5),
//                          endPoint: CGPoint(x: 1.0, y: 0.5),
//                          colors: [.red, .blue],
//                          locations: [0, 1])
//            designator.shadow(UIColor.yellow).cornerRadius(8)
//        }
//    }

//    private func updateLabelAppearance() {
//        // 以闭包的形式重置外观配置
//        label.resetDesign { (designator) in
//            // 12号蓝色默认字体, 内容为"更新外观后的文本标签"
//            designator.text("更新外观后的文本标签").font(12).color(.blue)
//            // 背景透明时, Label的阴影路径与文本一致
//            designator.shadow(.blue).cornerRadius(16)
//        }
//
//        // 创建Appearance实例, 并设置外观配置, 再应用到UI控件上
//        let designator = Designator()
//        designator.text(" 18号大字体, 带有背景 ").font(18).color(.white)
//        designator.background(.gray).cornerRadius(8)
//        designator.shadow(.blue).cornerRadius(8)
//        designator.applyValuator(to: bigLabel)
//    }

//    private func updateButtonAppearance() {
//        bgBtn.updateDesign { (designator) in
//            designator.background(.clear).cornerRadius(5)
//                .gradient(startPoint: CGPoint(x: 0, y: 0),
//                          endPoint: CGPoint(x: 1, y: 1),
//                          colors: [.red, .green, .blue],
//                          locations: [0.33, 0.66, 1.0])
//            designator.text("取消").color(.white).font(20, weight: .bold)
//            // 添加响应事件, 支持多事件同时添加, 默认为 touchUpInside
//            designator.event(.touchUpInside, for: self, action: #selector(designatorDemo))
//            designator.event(.touchDown, for: self, action: #selector(bgBtnTouchUpOutsideAction))
//        }
//
//        insertBtn.updateDesign { (designator) in
//            designator.background(.purple).cornerRadius(5)
//            designator.event(for: self, action: #selector(addAppearanceControl))
//            designator.text(nil).color(.white)
//        }
//    }

//    private func updateImageViewAppearance() {
//        imgView.updateDesign { (designator) in
//            designator.image(UIImage(named: "Lambert")!).cornerRadius(16)
//            designator.shadow(UIColor.red).cornerRadius(16)
//        }
//    }

    // MARK: Event response methods
    @objc func bgBtnTouchUpOutsideAction() {
        MLog("Touch up outside")
    }

    @objc func bgBtnTouchUpInsideAction() {
        MLog("Touch up inside")
//        bigLabel.updateDesign { (designator) in
//            designator.text(nil).color(.green)
//            designator.background(.orange)
//        }
    }
}
