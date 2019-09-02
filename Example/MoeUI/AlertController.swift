//
//  AlertController.swift
//  MoeUI
//
//  Created by Zed on 2019/8/17.
//

import UIKit
import MoeUI


class MoeAlertController: UIViewController, UIViewControllerTransitioningDelegate, MaskAlertAnimatorProtocol {
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        setupViewConstraint()
    }

    func setupViewConstraint() {
        maskBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: maskBtn, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ])

        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280),
            NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 128)
        ])

        setupBezelSizeConstraint()
    }

    open func setupBezelSizeConstraint() {}

    // MARK: UIViewControllerTransitioningDelegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MaskAlertAnimator(owner: self, transitionType: .present, animationType: .alert)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MaskAlertAnimator(owner: self, transitionType: .dismiss, animationType: .alert)
    }

    // MARK: SheetAnimatorProtocol
    func maskViewForAnimation() -> UIView {
        return maskBtn
    }

    func contentViewForAnimation() -> UIView {
        return contentView
    }

    // MARK: Getter & Setter
    private(set) lazy var maskBtn: UIButton = {
        let maskBtn = MoeUI.makeButton(toView: self.view) { (appear) in
            appear.background(color: .black)
        }
        maskBtn.alpha = 0.6
        maskBtn.addTarget(self, action: #selector(maskTapAction(_:)), for: .touchUpInside)
        return maskBtn
    }()

    private(set) lazy var contentView: UIView = {
        return MoeUI.makeView(toView: self.view) { (appear) in
            appear.background(color: UIColor(rgb: 0xEDEDED)).cornerRadius(16)
        }
    }()

    // MARK: Event Response
    @objc func maskTapAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


public extension MoeUI {
    class func alert() {
        if #available(iOS 9.0, *) {
            let topVC = UIApplication.moe.topViewController()

            let pickerVC = MoeAlertController()
            pickerVC.view.backgroundColor = .clear
            pickerVC.modalPresentationStyle = .overCurrentContext
            pickerVC.transitioningDelegate = pickerVC

            topVC?.present(pickerVC, animated: true, completion: nil)
            MLog(topVC)
        }
    }
}

