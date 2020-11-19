//
//  NavigationController.swift
//  MoeUI
//
//  Created by Zed on 2020/11/9.
//

import Foundation


/// 隐藏导航栏协议；遵守该协议的视图控制器的导航栏将被隐藏
public protocol HideNavigationBar {}
/// 透明导航栏协议；遵守该协议的视图控制器的导航栏背景色会被置为透明
public protocol TransparencyNavigationBar {}


/// 导航控制器基类
open class NavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 如果控制器遵守了 HideNavigationBar 协议，则需要隐藏导航栏
        var isBarHidden = false
        if (viewController as? HideNavigationBar != nil) { isBarHidden = true }
        setNavigationBarHidden(isBarHidden, animated: true)
        // 隐藏导航栏后会导致边缘右滑返回的手势失效，需要重新设置手势代码
        interactivePopGestureRecognizer?.delegate = self
        
        // 如果控制器遵守了 TransparencyNavigationBar 协议，则需要透明导航栏
        var isTransparency: UIImage? = nil
        if (viewController as? TransparencyNavigationBar != nil) { isTransparency = UIImage() }
        // 通过设置导航栏背景图片为空图，实现导航栏透明
        navigationBar.setBackgroundImage(isTransparency, for: .default)
        // 通过设置导航栏阴影图片为空图，去掉导航栏阴影
        navigationBar.shadowImage = isTransparency
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 子控制器数量大于1时，支持手势返回
        return children.count > 1
    }
}
