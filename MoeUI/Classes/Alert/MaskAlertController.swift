//
//  AlertController.swift
//  MoeUI
//
//  Created by Zed on 2019/8/29.
//

import UIKit


/// 遮罩弹窗控制器，请使用`present`方式展示，不能使用`push`方式
open class MaskAlertController: UIViewController, UIViewControllerTransitioningDelegate, MaskAlertAnimatorProtocol {
    // MARK: - Object Life Cycle
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

    // MARK: - View Life Cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        view.addSubview(maskBtn)
        view.addSubview(bezelView)
        setupConstraint()
        addConstraintsFor(bezelView, in: self.view)
        
        self.performSelector(onMainThread: #selector(wakeupMainThread), with: nil, waitUntilDone: false)
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
    
    /// 转场动画时长
    open var animationDuratoin: TimeInterval = 0.25
    
    /// 点击遮罩时，弹窗是否消失
    open var dismissWhenMaskTap: Bool = true {
        didSet { maskBtn.isUserInteractionEnabled = dismissWhenMaskTap }
    }
    
    /// 是否启用遮罩
    open var maskEnable: Bool = true {
        didSet { maskBtn.isHidden = !maskEnable }
    }
    
    // MARK: Subclass Should Override
    
    /// 子类重写该方法，返回要展示的自定义视图；
    /// 注意控制器应该持有该视图，避免被释放。但并不需要将其作为子视图添加至控制器根视图上
    /// - Returns: 自定义视图
    open func viewToAlert() -> UIView {
        let content = "请重写`viewToAlert`方法, 在方法中返回要弹出的自定义视图"
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

    // MARK: - UIViewControllerTransitioningDelegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MaskAlertAnimator(owner: self, transitionType: .present, animationType: animationType(), animationDuration: animationDuratoin)
        return animator
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MaskAlertAnimator(owner: self, transitionType: .dismiss, animationType: animationType(), animationDuration: animationDuratoin)
        return animator
    }

    // MARK: - SheetAnimatorProtocol
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


@objc extension MaskAlertController {
    /// 遮罩点击事件
    open func maskTapAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func wakeupMainThread() {
        /**
         执行`present`控制器跳转时，并不会立即触发转场动画的执行。因某些原因会有延迟触发的情况
         表现为目标控制器的视图已经生成，但转场动画相关方法不执行。此时随便点击屏幕就会触发转场动画执行
         目前解决方案：
            1. 在主线中执行`present`方法实现控制器跳转
            2. 在目标控制器内，执行主线程方法（无需操作，仅唤醒主线程）
         */
    }
}
