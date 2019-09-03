//
//  ProgressAlertController.swift
//  MoeUI
//
//  Created by Zed on 2019/9/2.
//

import UIKit


public class ProgressAlertController: MaskAlertController {

    var style: AlertDialog.Style
    var text: String

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(style: AlertDialog.Style, text: String) {
        self.style = style
        self.text = text
        super.init()
    }

    // MARK: View Life Cycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if style == .progress { self.dialog.indicator.startAnimating() }
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if style == .progress { self.dialog.indicator.stopAnimating() }
    }

    // MARK: Override Methods
    override public func viewToAlert() -> UIView {
        return self.dialog
    }

    public override func addConstraintsFor(_ alert: UIView, in superView: UIView) {
        alert.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: alert, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: alert, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1.0, constant: -48.0),
            NSLayoutConstraint(item: alert, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: superView, attribute: .left, multiplier: 1.0, constant: 24),
            NSLayoutConstraint(item: alert, attribute: .right, relatedBy: .lessThanOrEqual, toItem: superView, attribute: .right, multiplier: 1.0, constant: -24)
        ])
    }

    public override func animationType() -> MaskAlertAnimator.AnimationType {
        return .translation
    }

    // MARK: Getter & Setter
    private(set) lazy var dialog: AlertDialog = {
        return AlertDialog(style: style, text: text)
    }()
}
