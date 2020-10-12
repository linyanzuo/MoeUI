//
//  DialogView.swift
//  MoeUI
//
//  Created by Zed on 2019/8/29.
//

import UIKit
import MoeCommon


/// 提示对话框
public class AlertDialog: MoeView {
    /// 弹窗样式
    public enum Style {
        /// 纯文本提示
        case toast
        /// 转圈进度提示
        case progress
        /// 操作成功提示
        case success
        /// 操作失败提示
        case error
    }

    private let fontColor = UIColor(rgb: 0x666666)
    public var style: AlertDialog.Style
    public var message: String

    // MARK: Object Life Cycle
    
    public init(style: Style, text: String) {
        self.style = style
        self.message = text
        super.init(frame: .zero)
        setupSubview()
        setupConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("use `init(style: Style, text: String)` instead")
    }

    deinit {
        MLog("[\(self)] died!")
    }

    // MARK: Subviews Initialize
    
    public override func setupSubview() {
        self.updateDesign({ (des) in
            des.background(UIColor(rgb: 0xE7E8EA)).cornerRadius(6).border(1, color: UIColor(rgb: 0xD7D8DA))
        })
        label.text = message

        if style == .success || style == .error {
            let imageName = self.style == .success ? "common_icon_finish" : "common_icon_error"
            let frameworkBundle = Bundle(for: self.classForCoder)
            if let targetBundleUrl = frameworkBundle.url(forResource: "MoeUI", withExtension: "bundle"),
                let targetBundle = Bundle(url: targetBundleUrl) {
                imageView.image = UIImage(named: imageName, in: targetBundle, compatibleWith: nil)
            } else {
                imageView.image = UIImage(named: imageName, in: frameworkBundle, compatibleWith: nil)
            }
        }
        if style == .progress {
            indicator.startAnimating()
        }
    }

    public override func setupConstraint() {
        var labelTopConstraint: NSLayoutConstraint? = nil
        var labelBottomConstraint: NSLayoutConstraint? = nil

        switch self.style {
        case .progress:
            indicator.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints([
                NSLayoutConstraint(item: indicator, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 16),
                NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            ])
            labelTopConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: indicator, attribute: .bottom, multiplier: 1.0, constant: 8.0)
            labelBottomConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -20.0)
        case .success, .error:
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints([
                NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 16),
                NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0),
                NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)
            ])
            labelTopConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1.0, constant: 8.0)
            labelBottomConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -20.0)

//            separator.translatesAutoresizingMaskIntoConstraints = false
//            self.addConstraints([
//                NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1.0, constant: 16),
//                NSLayoutConstraint(item: separator, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
//                NSLayoutConstraint(item: separator, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
//                NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0)
//            ])
//
//            btn.translatesAutoresizingMaskIntoConstraints = false
//            self.addConstraints([
//                NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: separator, attribute: .bottom, multiplier: 1.0, constant: 0.0),
//                NSLayoutConstraint(item: btn, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
//                NSLayoutConstraint(item: btn, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
//                NSLayoutConstraint(item: btn, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
//                NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)
//            ])
        case .toast:
            labelTopConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 20.0)
            labelBottomConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -20.0)
        }

        label.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            labelTopConstraint!,
            NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 24),
            NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -24),
        ])
        if labelBottomConstraint != nil { self.addConstraint(labelBottomConstraint!) }
    }

    // MARK: Getter & Setter
    public private(set) lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.hidesWhenStopped = true
        indicator.color = UIColor(rgb: 0x999999)
        self.addSubview(indicator)

        return indicator
    }()

    public private(set) lazy var imageView: UIImageView = {
        return Designator.makeImageView(toView: self, nil)
    }()

    public private(set) lazy var label: MoeLabel = {
        let des = Designator()
        des.text("Loading").font(15, weight: .medium).color(self.fontColor).lines(0).alignment(.center)
        return des.makeLabel(toView: self)
    }()

//    private(set) lazy var separator: UIView = {
//        let appear = Appearance()
//        appear.background(color: UIColor(rgb: 0xf5f5f5))
//        return MoeUI.makeView(toView: self, with: appear)
//    }()
//
//    private(set) lazy var btn: MoeButton = {
//        let appear = Appearance()
//        appear.text("OK").font(16).color(UIColor(rgb: 0x666666))
//        return MoeUI.makeButton(toView: self, with: appear)
//    }()
}


