//
//  DialogView.swift
//  MoeUI
//
//  Created by Zed on 2019/8/29.
//

import UIKit


public class AlertDialog: UIView {
    public enum Style {
        case toast
        case progress
        case success
        case fail
    }

    private let themeColor = UIColor(rgb: 0x333333)
    var style: AlertDialog.Style
    var message: String

    // MARK: Object Life Cycle
    public init(style: Style, text: String) {
        self.style = style
        self.message = text
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("use `init(style: Style, text: String)` instead")
    }

    // MARK: Subviews Initialize
    private func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = 8

        label.text = message
        if style == .success || style == .fail {
            let imageName = self.style == .success ? "common_icon_finish" : "common_icon_error"
            let frameworkBundle = Bundle(for: self.classForCoder)
            if let targetBundleUrl = frameworkBundle.url(forResource: "MoeUI", withExtension: "bundle"),
                let targetBundle = Bundle(url: targetBundleUrl) {
                imageView.image = UIImage(named: imageName, in: targetBundle, compatibleWith: nil)
            } else {
                imageView.image = UIImage(named: imageName, in: frameworkBundle, compatibleWith: nil)
            }
        }
    }

    private func setupConstraints() {
        var labelTopConstraint: NSLayoutConstraint? = nil

        switch self.style {
        case .progress:
            indicator.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints([
                NSLayoutConstraint(item: indicator, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 16),
                NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            ])
            labelTopConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: indicator, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        case .success, .fail:
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints([
                NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 16),
                NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0),
                NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)
            ])
            labelTopConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        case .toast:
            labelTopConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 24.0)
        }

        label.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            labelTopConstraint!,
            NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 16),
            NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -16),
            NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -24.0)
        ])
    }

    // MARK: Getter & Setter
    private(set) lazy var label: MoeLabel = {
        let appear = Appearance()
        appear.text("Loading").font(15).color(self.themeColor).lines(0).alignment(.center)
        return MoeUI.makeLabel(toView: self, with: appear)
    }()

    private(set) lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.hidesWhenStopped = true
        indicator.color = self.themeColor
        self.addSubview(indicator)

        return indicator
    }()

    private(set) lazy var imageView: UIImageView = {
        return MoeUI.makeImageView(toView: self, nil)
    }()
}


