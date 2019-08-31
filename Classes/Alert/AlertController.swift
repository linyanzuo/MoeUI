//
//  AlertController.swift
//  MoeUI
//
//  Created by Zed on 2019/8/29.
//

import UIKit


public class AlertController: UIViewController, UIViewControllerTransitioningDelegate, AlertAnimatorProtocol {
    
    var bezelView: UIView

    // MARK: Object Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("use `init(style: Style, text: String)` or `init(customView: UIView)` instead")
    }

    public init(customView: UIView) {
        self.bezelView = customView
        super.init(nibName: nil, bundle: nil)
        setupSelf()
    }

    public init(style: AlertDialog.Style, text: String) {
        self.bezelView = AlertDialog(style: style, text: text)
        super.init(nibName: nil, bundle: nil)
        setupSelf()
    }

    private func setupSelf() {
        self.modalPresentationStyle = .overCurrentContext
        self.transitioningDelegate = self
    }

    // MARK: View Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow

        view.addSubview(maskBtn)
        view.addSubview(bezelView)
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
        bezelView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: bezelView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: bezelView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: bezelView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 24),
            NSLayoutConstraint(item: bezelView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: self.view, attribute: .right, multiplier: 1.0, constant: -24)
        ])
    }

    // MARK: Delegate Method
    // MARK: -- UIViewControllerTransitioningDelegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertAnimator(owner: self, transitionType: .present, animationType: .alert)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertAnimator(owner: self, transitionType: .dismiss, animationType: .alert)
    }

    // MARK: -- SheetAnimatorProtocol
    public func maskViewForAnimation() -> UIView {
        return maskBtn
    }

    public func contentViewForAnimation() -> UIView {
        return self.bezelView
    }

    // MARK: Event Response
    @objc func maskBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Getter & Setter
    private(set) lazy var maskBtn: UIButton = {
        let appear = Appearance()
        appear.alpha(0.6).background(color: .black)
        appear.event(target: self, action: #selector(maskBtnAction(_:)))
        return MoeUI.makeButton(with: appear)
    }()
}
