//
//  UIViewController.swift
//  MoeUI
//
//  Created by Zed on 2022/4/23.
//

import UIKit
import MoeCommon


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
    
    /// 将控制器添加至导航栈中，并展示其界面
    /// - Parameters:
    ///   - viewController: 要展示的视图控制器
    ///   - animated:       转场过程是否启用动画，默认为true
    func push(viewController: UIViewController, animated: Bool = true) {
        guard let navCtrler = wrappedValue.navigationController else {
            debugPrint("当前控制器【\(wrappedValue.moe.clazzName)】未处于导航栈中，无法完成PUSH操作")
            return
        }
        navCtrler.pushViewController(viewController, animated: animated)
    }
    
    /// 从导航栈中出栈，直至目标控制器处于栈顶，并展示其界面
    /// - Parameters:
    ///   - toViewController:   目标控制器
    ///   - animated:           转场过程是否启用动画，默认为true
    func pop(toViewController: UIViewController? = nil, animated: Bool = true) {
        guard let navCtrler = wrappedValue.navigationController else {
            debugPrint("当前控制器【\(wrappedValue.moe.clazzName)】未处于导航栈中，无法完成POP操作")
            return
        }
        if let vc = toViewController {
            navCtrler.popToViewController(vc, animated: animated)
        } else {
            navCtrler.popViewController(animated: animated)
        }
    }
    
    
    /// 呈现模态控制器，展示其界面。
    /// 通过「转场动画 + 控制器」形式实现的功能控件，都应该通过该方法呈现，而不是调用 `push(viewController: animated:)` 方法
    /// - Parameters:
    ///   - viewController: 要展示的视图控制器
    ///   - animated:       转场过程是否启用动画，默认为true
    ///   - completion:     转场动画执行完成后的回调闭包
    func present(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) { viewController.modalPresentationStyle = .fullScreen }
        wrappedValue.present(viewController, animated: animated, completion: completion)
    }
    
    /// 呈现模态视图(Model Present)，并使控制器根视图透明时可穿透（看到后面的内容）
    /// 通过「转场动画 + 控制器」形式实现的功能控件，或需要内容穿透，应该通过该方法呈现，而不是调用`present(viewController: animated: completion:)`方法
    /// - Parameters:
    ///   - viewController: 要展示的视图控制器
    ///   - animated:       转场过程是否启用动画，默认为true
    ///   - completion:     转场动画执行完成后的回调闭包
    func transparencyPresent(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil)  {
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
//        if #available(iOS 13.0, *) { wrappedValue.modalPresentationStyle = .overFullScreen }
        wrappedValue.present(viewController, animated: animated, completion: completion)
    }
    
    /// 释放模态控制器，移除其界面。
    /// - Parameters:
    ///   - animated:       转场过程是否启用动画，默认为true
    ///   - completion:     转场动画执行完成后的回调闭包
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        wrappedValue.dismiss(animated: animated, completion: completion)
    }
}

