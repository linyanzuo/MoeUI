//
//  Created by Zed on 2020/8/18.
//  Copyright © 2020 www.moemone.com. All rights reserved.
//


import UIKit


public extension TypeWrapperProtocol where WrappedType: UIViewController {
    
    /// 加载指定Storyboard文件，实例化其中控制器场景的`identifier`与`调用类`同名的控制器实例
    ///
    /// 调用该方法前，请确认Storyboard文件已正确配置
    /// 1. 确认`MainBundle`内存在指定名称的`Storyboard`文件，默认为"Main.storyboard"
    /// 2. 在SB文件中，选择调用类对应的`View Controller Scene`，在「Identity inspector > Custom Class」内配置:
    ///    1. CustomClass为调用类类型
    ///    2. Module为相应的项目模块
    ///    3. Storyboard ID为调用类类名
    /// - Parameter storyboardFileName: MainBundle内的Storyboard文件名，默认为"Main"
    /// - Returns:
    static func storyboardInstance(_ storyboardFileName: String = "Main") -> WrappedType {
        let storyboard = UIStoryboard(name: storyboardFileName, bundle: nil)
        let vcIdentifier = String(describing: WrappedType.self)
        guard let vc = storyboard.instantiateViewController(withIdentifier: vcIdentifier) as? WrappedType else {
            fatalError("加载Storyboard实例失败，请查看「storyboardInstance」方法说明")
        }
        return vc
    }
    
    /// 呈现模态视图(Model Present)时，清除其背景色
    func clearPresentationBackground()  {
        wrappedValue.providesPresentationContextTransitionStyle = true
        wrappedValue.definesPresentationContext = true
        wrappedValue.modalPresentationStyle = .overCurrentContext
    }
    
}
