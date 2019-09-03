//
//  TopViewController.swift
//  MoeUI
//
//  Created by Zed on 2019/8/17.
//

public extension TypeWrapperProtocol where WrappedType: UIApplication {
    static func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController { return topViewController(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController {
            let moreNav = tab.moreNavigationController
            if let top = moreNav.topViewController, top.view.window != nil { return topViewController(base: top) }
            else if let selected = tab.selectedViewController { return topViewController(base: selected) }
        }
        if let presented = base?.presentedViewController { return topViewController(base: presented) }
        return base
    }
}

public extension TypeWrapperProtocol where WrappedType: UIViewController {
    func clearPresentationBackground()  {
        wrappedValue.providesPresentationContextTransitionStyle = true
        wrappedValue.definesPresentationContext = true
        wrappedValue.modalPresentationStyle = .overCurrentContext
    }
}
