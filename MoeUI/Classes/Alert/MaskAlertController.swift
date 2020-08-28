//
//  AlertController.swift
//  MoeUI
//
//  Created by Zed on 2019/8/29.
//

import UIKit


/// 遮罩弹窗控制器，请使用「present」方式展示
open class MaskAlertController: UIViewController, UIViewControllerTransitioningDelegate, MaskAlertAnimatorProtocol {
    /// 点击遮罩时，弹窗是否消失
    open var dismissWhenMaskTap: Bool = true {
        didSet { maskBtn.isUserInteractionEnabled = dismissWhenMaskTap }
    }
    
    open var maskEnable: Bool = true {
        didSet { maskBtn.isHidden = !maskEnable }
    }
    
    // MARK: 子类应该重写的方法
    
    /// 控制器要展示的自定义视图
    /// - Returns: 自定义视图
    open func viewToAlert() -> UIView {
        let content = "Plaese override the `viewToAlert` method, and return custom view which you want to alert"
        let bezelView = AlertDialog(style: .toast, text: content)
        return bezelView
    }
    
    /// 为控制器要展示的视图添加AutoLayout约束
    /// - Parameters:
    ///   - alertView: 要展示的视图，由「viewToAlert」方法返回
    ///   - superView: 要展示视图的父视图，即控制器根视图
    open func addConstraintsFor(_ alertView: UIView, in superView: UIView) {
        alertView.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints([
            NSLayoutConstraint(item: alertView, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: alertView, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: alertView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: superView, attribute: .left, multiplier: 1.0, constant: 24),
            NSLayoutConstraint(item: alertView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: superView, attribute: .right, multiplier: 1.0, constant: -24)
        ])
    }
    
    /// 为控制器选择转场动画的具体类型
    /// - Returns: 支持的转场动画类型
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
        setupConstraint()
        addConstraintsFor(bezelView, in: self.view)
    }

    private func setupConstraint() {
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
        let des = Designator()
        des.general.alpha(0.6)
        des.background(.black)
        des.event(.touchUpInside, for: self, action: #selector(self.maskTapAction(_:)))
        let btn = des.makeButton()
        btn.isHidden = !self.maskEnable
        return btn
    }()

    private(set) lazy var bezelView: UIView = {
        return self.viewToAlert()
    }()
}
