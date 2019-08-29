//
//  DialogView.swift
//  MoeUI
//
//  Created by Zed on 2019/8/29.
//

import UIKit


public class AlertDialog: UIView {
    public enum Style {
        case progress
        case success
        case error
    }

    private let themeColor = UIColor(rgb: 0x333333)
    var style: AlertDialog.Style?
    var message: String?

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
        let imageName = self.style == .success ? "common_icon_finish" : "common_icon_error"
        imageView.image = UIImage(named: imageName)
        label.text = message
    }

    private func setupConstraints() {
        if self.style == .progress {
            indicator.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints([
                NSLayoutConstraint(item: indicator, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 16),
                NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            ])
        } else if self.style == .success || self.style == .error {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints([
                NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 16),
                NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0),
                NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)
            ])
        }

        let constraintTarget = self.style == .progress ? self.indicator : self.imageView
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addConstraints([
            NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: constraintTarget, attribute: .bottom, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 24),
            NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -24),
            NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -16.0)
        ])
    }

    // MARK: Getter & Setter
    private(set) lazy var label: MoeLabel = {
        let appear = Appearance()
        appear.text("Loading").font(15).color(self.themeColor).lines(0)
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


