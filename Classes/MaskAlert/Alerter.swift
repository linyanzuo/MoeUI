//
//  Alerter.swift
//  MoeUI
//
//  Created by Zed on 2019/9/8.
//

import UIKit


public class Alerter: NSObject {
    // MARK: Alert in view
//    public class func showProgress(text: String, in view: UIView) {
//        showDialog(style: .progress, text: text, in: view)
//    }
//
//    public class func showSuccess(text: String, in view: UIView) {
//        showDialog(style: .success, text: text, in: view)
//    }
//
//    public class func showError(text: String, in view: UIView) {
//        showDialog(style: .fail, text: text, in: view)
//    }
//
//    public class func showToast(text: String, in view: UIView) {
//        showDialog(style: .toast, text: text, in: view)
//    }


    // MARK: Alert in view
    public class func showDialog(style: AlertDialog.Style, text: String, in view: UIView, with identifier: String? = nil) {
        showCustom(AlertDialog(style: style, text: text), in: view, with: identifier)
    }

    public class func showCustom(_ customView: UIView, in view: UIView, with identifier: String? = nil) {
        assert(Thread.current.isMainThread == true, "Alerter must perform in main thread")

        var alertView: AlertView? = nil
        for subview in view.subviews {
            if subview.isMember(of: AlertView.classForCoder()) { alertView = subview as? AlertView }
        }
        if alertView == nil {
            alertView = AlertView(frame: .zero)
            view.addSubview(alertView!)

            alertView!.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints([
                NSLayoutConstraint(item: alertView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: alertView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: alertView!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: alertView!, attribute: .right, relatedBy: .equal, toItem: view, attribute: . right, multiplier: 1.0, constant: 0.0)
            ])
        }
        alertView!.addAlert(customView: customView)
    }

    public class func hide(in view: UIView, with identifier: String? = nil) {
        assert(Thread.current.isMainThread == true, "Alerter must perform in main thread")

        for subview in view.subviews {
            if subview.isMember(of: AlertView.classForCoder()) {
                let alertView = subview as! AlertView
                alertView.removeAlert(with: identifier, completionHandler: nil)
            }
        }
    }

    // MARK: Alert in window
    public class func showGlobalDialog(style: AlertDialog.Style, text: String, with identifier: String? = nil) {
        showGlobalCustom(AlertDialog(style: style, text: text), with: identifier)
    }

    public class func showGlobalCustom(_ customView: UIView, with identifier: String? = nil) {
        assert(Thread.current.isMainThread == true, "Alert must perform in main thread")

        let window = AlertWindow.shared
        window.addAlert(customView: customView)
    }

    public class func hideGlobal() {
        assert(Thread.current.isMainThread == true, "Alert must perform in main thread")

        let window = AlertWindow.shared
        window.removeAlert()
    }
}
