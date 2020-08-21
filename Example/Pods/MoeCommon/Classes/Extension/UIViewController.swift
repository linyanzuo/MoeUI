//
//  Created by Zed on 2020/8/18.
//  Copyright © 2020 www.moemone.com. All rights reserved.
//


import UIKit


public extension TypeWrapperProtocol where WrappedType: UIViewController {
    
    /// 呈现模态视图(Model Present)时，清除其背景色
    func clearPresentationBackground()  {
        wrappedValue.providesPresentationContextTransitionStyle = true
        wrappedValue.definesPresentationContext = true
        wrappedValue.modalPresentationStyle = .overCurrentContext
    }
    
}
