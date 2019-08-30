//
//  GlobalAlertController.swift
//  MoeUI
//
//  Created by Zed on 2019/8/30.
//

import UIKit


public class GlobalAlertManager {
    typealias Alert = (id: String, view: UIView)

    public static let shared = GlobalAlertManager()
    private let window: GlobalAlertWindow
    private var alerts: [Alert] = []

    private init() {
        window = GlobalAlertWindow.shared
        window.completionHandler = { self.hide(with: nil) }
    }

    // MARK: Private Method
    private func generateIdentifier() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddHHmmssSSSSSS"
        let dateDesc = formatter.string(from: Date())
//        let random = Int(arc4random_uniform(8999) + 1000)
        return dateDesc
    }

    // MARK: Public Method
    public func alert(customView: UIView, with identifier: String? = nil) {
        guard Thread.current.isMainThread == true else {
            MLog("Alert must perform in main thread")
            return
        }

        var id = identifier
        if id == nil { id = self.generateIdentifier() }

        for alert in alerts {
            if alert.id == id {
                MLog("Can't alert view which identifier \(id!) is already in use. ")
                return
            }
        }

        if window.subviews.count > 1 { window.bringSubviewToFront(window.maskBtn) }
        window.isHidden = false
        window.addSubview(customView)
        alerts.append((id!, customView))
        MLog(window.subviews)

        customView.translatesAutoresizingMaskIntoConstraints = false
        window.addConstraints([
            NSLayoutConstraint(item: customView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: customView, attribute: .centerY, relatedBy: .equal, toItem: window, attribute: .centerY, multiplier: 1.0, constant: 0.0),
        ])
    }

    public func alert(style: AlertDialog.Style, text: String, with identifier: String? = nil) {
        let dialog = AlertDialog(style: style, text: text)
        alert(customView: dialog, with: identifier)
    }

    public func hide(with identifier: String? = nil) {
        guard Thread.current.isMainThread == true else {
            MLog("Alert must perform in main thread")
            return
        }

        var targetAlert: Alert? = nil
        if identifier == nil {
            targetAlert = alerts.last
            alerts.removeLast()
        } else {
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
            } else { alerts.remove(at: index) }
        }

        guard targetAlert != nil else {
            MLog("There's no view alert now")
            return
        }

        targetAlert!.view.removeFromSuperview()
        if let newTarget = alerts.last {
            window.bringSubviewToFront(newTarget.view)
        } else {
            window.isHidden = true
        }
    }
}
