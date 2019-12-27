//
//  UIKit+Moe.swift
//  MoeCommon
//
//  Created by Zed on 2019/11/19.
//

import UIKit

// MARK: UIColor

public extension UIColor {
    /// 随机颜色
    class var random: UIColor {
        get {
            let red = CGFloat(arc4random() % 256) / 255.0
            let green = CGFloat(arc4random() % 256) / 255.0
            let blue = CGFloat(arc4random() % 256) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    /// 返回RGB值对应的`UIColor`实例
    /// - Parameter rgb: RGB值的16进制表示，如`0xFFFFFF`
    convenience init(rgb: UInt32) {
        let rgba = rgb << 8 | 0x000000FF
        self.init(rgba: rgba)
    }

    /// 返回RGBA值对应的`UIColor`实例
    /// - Parameter rgba: RGBA值的16进制表示，如`0x000000FF`
    convenience init(rgba: UInt32) {
        let red = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let blue = CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
        let alpha = CGFloat(rgba & 0x000000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


// MARK: UIViewController

public extension TypeWrapperProtocol where WrappedType: UIViewController {
    static func storyboardInstance(_ storyboardName: String = "Main") -> WrappedType {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let className = NSStringFromClass(WrappedType.classForCoder())
        return storyboard.instantiateViewController(withIdentifier: className) as! WrappedType
    }
    
    /// 呈现模态视图(Model Present)时，清除其背景色
    func clearPresentationBackground()  {
        wrappedValue.providesPresentationContextTransitionStyle = true
        wrappedValue.definesPresentationContext = true
        wrappedValue.modalPresentationStyle = .overCurrentContext
    }
}


// MARK: UIApplication

public extension TypeWrapperProtocol where WrappedType: UIApplication {
    /// 返回指定控制器中，控制器层级最高(正在交互)的控制器
    /// - Parameter base: 指定的控制器
    static func topViewController(
        base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController)
        -> UIViewController?
    {
        if let nav = base as? UINavigationController
        { return topViewController(base: nav.visibleViewController) }
        
        if let tab = base as? UITabBarController {
            let moreNav = tab.moreNavigationController
            
            if let top = moreNav.topViewController, top.view.window != nil
            { return topViewController(base: top) }
            else if let selected = tab.selectedViewController
            { return topViewController(base: selected) }
        }
        
        if let presented = base?.presentedViewController
        { return topViewController(base: presented) }
        
        return base
    }
}

