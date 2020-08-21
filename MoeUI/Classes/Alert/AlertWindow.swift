//
//  GlobalAlertWindow.swift
//  MoeUI
//
//  Created by Zed on 2019/8/30.
//

import UIKit


final class AlertWindow: UIWindow {
    
    static let shared = AlertWindow()
    internal var completionHandler: (() -> Void)?

    // MARK: Object Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private init(){
        super.init(frame: UIScreen.main.bounds)
        setupViews()
    }

    public func addAlert(customView: UIView, with identifier: String? = nil) {
        if isHidden == true { isHidden = false }
        alertView?.addAlert(customView: customView, with: identifier)
    }

    public func removeAlert(with identifier: String? = nil) {
        alertView?.removeAlert(with: identifier) { [weak self] in
            if self?.alertView?.alerts.count == 0 {
                self?.isHidden = true
                self?.alertView = nil
            }
        }
    }

    // MARK: Private Method
    private func setupViews() {
        windowLevel = UIWindow.Level.statusBar + 1
        backgroundColor = .clear
        isHidden = true
    }

    // MARK: Getter & Setter
    private var _alertView: AlertView?
    private(set) var alertView: AlertView? {
        get {
            guard _alertView == nil else { return _alertView }
            _alertView = AlertView(frame: .zero)
            _alertView!.maskTapHandler = { [weak self] in
                self?.removeAlert()
            }
            _alertView!.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(_alertView!)
            self.addConstraints([
                NSLayoutConstraint(item: _alertView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: _alertView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: _alertView!, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: _alertView!, attribute: .right, relatedBy: .equal, toItem: self, attribute: . right, multiplier: 1.0, constant: 0.0)
            ])
            return _alertView
        }
        set { _alertView = newValue }
    }
}
