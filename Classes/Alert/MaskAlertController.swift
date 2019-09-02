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
        let appear = Appearance()
        appear.background(color: .white).cornerRadius(8.0)
        let bezelView = MoeUI.makeView(with: appear)

        let content = "Plaese override the `viewToAlert` method, and return custom view which you want to alert"
        let label = MoeUI.makeLabel(toView: bezelView) { (appear) in
            appear.text(content).font(15).color(.black).lines(0)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        bezelView.addConstraints([
            NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: bezelView, attribute: .top, multiplier: 1.0, constant: 24),
            NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: bezelView, attribute: .bottom, multiplier: 1.0, constant: -24),
            NSLayoutConstraint(item: label, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: bezelView, attribute: .left, multiplier: 1.0, constant: 16),
            NSLayoutConstraint(item: label, attribute: .right, relatedBy: .lessThanOrEqual, toItem: bezelView, attribute: .right, multiplier: 1.0, constant: -16)
        ])

        return bezelView
    }

    @objc open func maskTapAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Object Life Cycle
    var bezelView: UIView?

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
        self.setupSelf()
        self.bezelView = self.viewToAlert()
    }

    private func setupSelf() {
        self.modalPresentationStyle = .overCurrentContext
        self.transitioningDelegate = self
    }

    // MARK: View Life Cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        view.addSubview(maskBtn)
        view.addSubview(bezelView!)
        setupConstraints()
    }

    private func setupConstraints() {
        maskBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: maskBtn, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ])

        guard bezelView != nil else { return }
        bezelView!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: bezelView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: bezelView!, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: bezelView!, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 24),
            NSLayoutConstraint(item: bezelView!, attribute: .right, relatedBy: .lessThanOrEqual, toItem: self.view, attribute: .right, multiplier: 1.0, constant: -24)
        ])
    }

    // MARK: Delegate Method
    // MARK: -- UIViewControllerTransitioningDelegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MaskAlertAnimator(owner: self, transitionType: .present, animationType: .alert)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MaskAlertAnimator(owner: self, transitionType: .dismiss, animationType: .alert)
    }

    // MARK: -- SheetAnimatorProtocol
    public func maskViewForAnimation() -> UIView {
        return maskBtn
    }

    public func contentViewForAnimation() -> UIView {
        return bezelView!
    }

    // MARK: Getter & Setter
    private(set) lazy var maskBtn: UIButton = {
        let appear = Appearance()
        appear.alpha(0.6).background(color: .black)
        appear.event(target: self, action: #selector(maskTapAction(_:)))
        return MoeUI.makeButton(with: appear)
    }()
}
