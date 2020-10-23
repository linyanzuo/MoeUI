//
//  GlobalAlertWindow.swift
//  MoeUI
//
//  Created by Zed on 2019/8/30.
//

import UIKit


final class AlertWindow: UIWindow {
    /// 单例
    static let shared = AlertWindow()
    private init(){
        super.init(frame: UIScreen.main.bounds)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var identifier: String?
    internal var completionHandler: (() -> Void)?
    
    public var maskEnable: Bool = false {
        didSet { alertView.maskEnable = maskEnable }
    }
    
    public var hideWhenMaskTap: Bool = true {
        didSet {
            alertView.maskTapHandler = hideWhenMaskTap ? { self.removeAlert(with: self.identifier) } : nil
        }
    }

    public func addAlert(customView: UIView, with identifier: String? = nil) {
        // AlertWindow作为AlertView的容器，动画及事件均由AlertView负责处理
        self.identifier = identifier
        if isHidden == true { isHidden = false }
        if (alertView.superview == nil) { addSubview(alertView) }
        alertView.addAlert(customView: customView, with: identifier)
    }
    
    public func removeAlert(with identifier: String? = nil) {
        // 由AlertView先执行移除动画，执行结束后再隐藏AlertWindow
        self.alertView.prepareToRemoveAlert(with: identifier) { [weak self] in
            if self?.alertView.alerts.count == 0 { self?.isHidden = true }
        }
    }

    // MARK: Private Method
    private func setupViews() {
        windowLevel = UIWindow.Level.statusBar + 1
        backgroundColor = .clear
        isHidden = true
    }

    // MARK: Getter & Setter
    
    private(set) lazy var alertView: AlertView = {
        let alertView = AlertView(frame: .zero)
        alertView.maskEnable = maskEnable
        alertView.hideWhenMaskTap = false
        alertView.removeFromSuperViewOnHide = false
        // 由AlertView的遮罩点击事件，触发AlertWindow的移动事件
        alertView.maskTapHandler = hideWhenMaskTap ? { self.removeAlert(with: self.identifier) } : nil
        alertView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(alertView)
        self.addConstraints([
            NSLayoutConstraint(item: alertView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: alertView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: alertView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: alertView, attribute: .right, relatedBy: .equal, toItem: self, attribute: . right, multiplier: 1.0, constant: 0.0)
        ])
        return alertView
    }()
}
