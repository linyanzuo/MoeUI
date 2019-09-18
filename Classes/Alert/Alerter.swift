//
//  Alerter.swift
//  MoeUI
//
//  Created by Zed on 2019/9/8.
//

import UIKit


public typealias AlertIdentifier = String


public class HUD {
    public class func showSuccess(text: String, continued: TimeInterval = 1.0) {
        showHUD(style: .success, text: text, continued: continued)
    }

    public class func showError(text: String, continued: TimeInterval = 1.0) {
        showHUD(style: .error, text: text, continued: continued)
    }

    public class func showToast(text: String, continued: TimeInterval = 1.0) {
        showHUD(style: .toast, text: text, continued: continued)
    }

    public class func showHUD(style: AlertDialog.Style, text: String, continued: TimeInterval) {
        let dialog = AlertDialog(style: style, text: text)
        showCustomHUD(view: dialog, continued: continued)
    }

    public class func showCustomHUD(view: UIView, continued: TimeInterval) {
        let id = Alerter.generateIdentifier()
        Alerter.showGlobal(view, with: id)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + continued, execute: {
            Alerter.hideGlobal(with: id)
        })
    }

    public class func showProgress(text: String) -> AlertIdentifier {
        let dialog = AlertDialog(style: .progress, text: text)
        return showCustomHUD(view: dialog)
    }

    public class func hide(with identifier: AlertIdentifier) {
        Alerter.hideGlobal(with: identifier)
    }

    public class func showCustomHUD(view: UIView) -> AlertIdentifier {
        let id = Alerter.generateIdentifier()
        Alerter.showGlobal(view, with: id)
        return id
    }
}


public class Alerter: NSObject {
    // MARK: Alert in view
    public class func show(_ customView: UIView, in view: UIView, with identifier: String) {
        checkThread()

        var alertView: AlertView? = nil
        for subview in view.subviews {
            if subview.isMember(of: AlertView.classForCoder()) { alertView = subview as? AlertView }
        }
        if alertView == nil {
            alertView = AlertView(frame: .zero)
            alertView?.maskTapHandler = {
                self.hide(in: view, with: identifier)
            }
            view.addSubview(alertView!)

            alertView!.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints([
                NSLayoutConstraint(item: alertView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: alertView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: alertView!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: alertView!, attribute: .right, relatedBy: .equal, toItem: view, attribute: . right, multiplier: 1.0, constant: 0.0)
            ])
        }
        alertView!.addAlert(customView: customView, with: identifier)
    }

    public class func hide(in view: UIView, with identifier: String) {
        checkThread()
        for subview in view.subviews {
            if subview.isMember(of: AlertView.classForCoder()) {
                let alertView = subview as! AlertView
                alertView.removeAlert(with: identifier, completionHandler: nil)
            }
        }
    }

    // MARK: Alert in window
    public class func showGlobal(_ customView: UIView, with identifier: AlertIdentifier) {
        checkThread()
        AlertWindow.shared.addAlert(customView: customView, with: identifier)
    }

    public class func hideGlobal(with identifier: AlertIdentifier) {
        checkThread()
        AlertWindow.shared.removeAlert(with: identifier)
    }

    // MARK: Generate Identifier
    public class func generateIdentifier() -> AlertIdentifier {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddHHmmssSSSSSS"
        let dateDesc = formatter.string(from: Date())
        //        let random = Int(arc4random_uniform(8999) + 1000)
        return dateDesc
    }

    // MARK: Private Method
    private class func checkThread() {
        assert(Thread.current.isMainThread == true, "MoeUI.Alert needs to be accessed on the main thread.")
    }
}
