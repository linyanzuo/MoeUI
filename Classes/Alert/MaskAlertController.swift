//
//  AlertController.swift
//  MoeUI
//
//  Created by Zed on 2019/8/29.
//

import UIKit


open class MaskAlertController: UIViewController, UIViewControllerTransitioningDelegate, MaskAlertAnimatorProtocol {
    // MARK: Subclass should override methods
    open func viewToAlert() -> UIView {
        let content = "Plaese override the `viewToAlert` method, and return custom view which you want to alert"
        let bezelView = AlertDialog(style: .toast, text: content)
        return bezelView
    }

    open func addConstraintsFor(_ alert: UIView, in superView: UIView) {
        alert.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints([
            NSLayoutConstraint(item: alert, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: alert, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: alert, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: superView, attribute: .left, multiplier: 1.0, constant: 24),
            NSLayoutConstraint(item: alert, attribute: .right, relatedBy: .lessThanOrEqual, toItem: superView, attribute: .right, multiplier: 1.0, constant: -24)
            ])
    }

    open func animationType() -> MaskAlertAnimator.AnimationType {
        return .external
    }

    @objc open func maskTapAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Object Life Cycle
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
        self.setupSelf()
    }

    private func setupSelf() {
        self.moe.clearPresentationBackground()
        self.transitioningDelegate = self
    }

    // MARK: View Life Cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        view.addSubview(maskBtn)
        view.addSubview(bezelView)
        setupConstraints()
        addConstraintsFor(bezelView, in: self.view)
    }

    private func setupConstraints() {
        maskBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: maskBtn, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ])
    }

    // MARK: Delegate Method
    // MARK: -- UIViewControllerTransitioningDelegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MaskAlertAnimator(owner: self, transitionType: .present, animationType: self.animationType())
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MaskAlertAnimator(owner: self, transitionType: .dismiss, animationType: self.animationType())
    }

    // MARK: -- SheetAnimatorProtocol
    public func maskViewForAnimation() -> UIView {
        return maskBtn
    }

    public func contentViewForAnimation() -> UIView {
        return bezelView
    }

    // MARK: Getter & Setter
    private(set) lazy var maskBtn: UIButton = {
        let appear = Appearance()
        appear.alpha(0.6).background(color: .black)
        appear.event(target: self, action: #selector(maskTapAction(_:)))
        return MoeUI.makeButton(with: appear)
    }()

    private(set) lazy var bezelView: UIView = {
        return self.viewToAlert()
    }()
}
