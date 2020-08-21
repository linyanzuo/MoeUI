//
//  Created by Zed on 2020/8/18.
//  Copyright © 2020 www.moemone.com. All rights reserved.
//

import UIKit


public extension TypeWrapperProtocol where WrappedType: UIApplication {
    
    /// 返回指定控制器中，控制器层级最高(正在交互)的控制器
    /// - Parameter base: 指定的控制器
    static func topViewController(
        base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
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
