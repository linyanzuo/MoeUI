//
//  MaskAlertView.swift
//  MoeUI
//
//  Created by Zed on 2019/9/8.
//

import UIKit


struct Alert {
    var id: String
    var view: UIView
}


/// popup view used for alert
public class AlertView: BaseView {
    private(set) var alerts: [Alert] = []
    private var targetAlert: Alert? = nil

    let kMaskAlpha: CGFloat = 0.4
    let kCustomOpacityAnimKey = "customOpacityAnimation"
    let kMaskOpacityAnimKey = "maskOpacityAnimation"

    public var isMaskEnable = true
    public var useAnaimation = true
    public var removeFromSuperViewOnHide = true
    public var completionHandler: (() -> Void)?
    public var maskTapHandler: (() -> Void)?

    deinit {
        MLog("[\(self)] died!")
    }

    override func setupViews() {
        self.backgroundColor = .clear
        self.addSubview(maskBtn)

        maskTapHandler = {
            self.removeAlert(completionHandler: nil)
        }
    }

    override func setupConstraints() {
        maskBtn.isHidden = !isMaskEnable
        guard isMaskEnable == true else { return }
        maskBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: maskBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        ])
    }

    public func addAlert(customView: UIView, with identifier: String? = nil) {
        maskBtn.isUserInteractionEnabled = false
        var id = identifier
        if id == nil { id = self.generateIdentifier() }
        for alert in alerts {
            if alert.id == id {
                MLog("Can't alert view which identifier \(id!) is already in use. ")
                return
            }
        }
        let alert = Alert(id: id!, view: customView)
        if alerts.count > 0 { bringSubviewToFront(maskBtn) }
        alerts.append(alert)
        addSubview(customView)

        customView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            NSLayoutConstraint(item: customView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: customView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: customView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .left, multiplier: 1.0, constant: 24),
            NSLayoutConstraint(item: customView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: self, attribute: .right, multiplier: 1.0, constant: -24)
        ])

        if useAnaimation == true {
            addAlphaAnimation(to: alert, transitionType: .present)
            if alerts.count == 0 { addMaskAnimation(transitionType: .present) }
        }
        else { maskBtn.isUserInteractionEnabled = true }
    }

    public func removeAlert(with identifier: String? = nil, completionHandler: (() -> Void)?) {
        maskBtn.isUserInteractionEnabled = false
        guard alerts.count > 0 else {
            MLog("There's no view alert now")
            return
        }
        self.completionHandler = completionHandler

        if identifier != nil {
            var index = 0
            for alert in alerts {
                if alert.id == identifier {
                    targetAlert = alert
                    break
                }
                index += 1
            }
            if targetAlert == nil {
                MLog("Can't hide view which identifier \(identifier!) is not in use")
                return
            }
        }
        else { targetAlert = alerts.last }

        var shouldMaskDismiss = false
        if alerts.count >= 2 {
            let newTarget = alerts[alerts.count - 2]
            bringSubviewToFront(newTarget.view)
        } else { shouldMaskDismiss = true }

        if useAnaimation == true {
            addAlphaAnimation(to: targetAlert!, transitionType: .dismiss)
            if shouldMaskDismiss == true { addMaskAnimation(transitionType: .dismiss) }
        }
        else { done(with: targetAlert!) }
    }

    private func done(with alert: Alert) {
        for index in 0 ..< alerts.count {
            if alerts[index].id == targetAlert?.id {
                alerts.remove(at: index)
                break
            }
        }
        alert.view.removeFromSuperview()
        if alerts.count == 0 && removeFromSuperViewOnHide == true {
            self.removeFromSuperview()
        }
        maskBtn.isUserInteractionEnabled = true
        completionHandler?()
    }

    private func generateIdentifier() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddHHmmssSSSSSS"
        let dateDesc = formatter.string(from: Date())
//        let random = Int(arc4random_uniform(8999) + 1000)
        return dateDesc
    }

    // MARK: Event Response
    @objc func maskTapAction(_ sender: UIButton) {
        maskTapHandler?()
    }

    // MARK: Getter & Setter
    private(set) lazy var maskBtn: UIButton = {
        let appear = Appearance()
        appear.alpha(kMaskAlpha).background(color: UIColor(rgb: 0x484848))
        appear.event(target: self, action: #selector(maskTapAction(_:)))
        return MoeUI.makeButton(with: appear)
    }()

    // Todo: 。。。
//    private lazy var alertQueue: OperationQueue = {
//        let queue = OperationQueue()
//        queue.name = "AlertView.AlertOperationQueue"
//        return queue
//    }()
}


// MARK: AlertView Animation
extension AlertView: CAAnimationDelegate {
    public enum TransitionType {
        case present
        case dismiss
    }

    private func animationDuration() -> TimeInterval {
        return 0.25
    }

    private func addMaskAnimation(transitionType: TransitionType) {
        let maskAlphaAnim = CABasicAnimation(keyPath: "opacity")
        maskAlphaAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskAlphaAnim.isRemovedOnCompletion = true
        maskAlphaAnim.duration = animationDuration()
        maskAlphaAnim.delegate = self

        if transitionType == .present {
            maskAlphaAnim.fromValue = 0.0
            maskAlphaAnim.toValue = kMaskAlpha
            maskBtn.alpha = kMaskAlpha
        } else if transitionType == .dismiss {
            maskAlphaAnim.fromValue = kMaskAlpha
            maskAlphaAnim.toValue = 0.0
            maskBtn.alpha = 0.0
        }
        maskBtn.layer.add(maskAlphaAnim, forKey: kMaskOpacityAnimKey)
    }

    private func addAlphaAnimation(to alert: Alert, transitionType: TransitionType) {
        let customAlphaAnim = CABasicAnimation(keyPath: "opacity")
        customAlphaAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        customAlphaAnim.isRemovedOnCompletion = true
        customAlphaAnim.duration = animationDuration()
        customAlphaAnim.delegate = self
        customAlphaAnim.setValue(alert, forKey: "alert")
        customAlphaAnim.setValue(transitionType, forKey: "transitionType")

        let customView = alert.view
        if transitionType == .present {
            customAlphaAnim.fromValue = 0.0
            customAlphaAnim.toValue = customView.alpha
        } else if transitionType == .dismiss {
            customAlphaAnim.fromValue = customView.alpha
            customAlphaAnim.toValue = 0.0
        }
        customView.layer.add(customAlphaAnim, forKey: kCustomOpacityAnimKey)
    }

    // MARK: CAAnimationDelegate
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let alert = anim.value(forKey: "alert") as? Alert,
            let transitionType = anim.value(forKey: "transitionType") as? TransitionType
        {
            if transitionType == .dismiss { self.done(with: alert) }
            else { maskBtn.isUserInteractionEnabled = true }
        }
        MLog("Animation did stop")
    }
}
