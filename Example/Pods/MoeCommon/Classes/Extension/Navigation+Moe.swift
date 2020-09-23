//
//  Created by Zed on 2020/8/18.
//  Copyright © 2020 www.moemone.com. All rights reserved.
//
/**
 【导航栏】相关扩展
 */

import UIKit


// MARK: - UIBarButtonItem Extension
public extension UIBarButtonItem {
    /// 根据图标名称、响应目标及事件生成导航栏按钮
    /// - Parameters:
    ///   - imageName:      图标名称
    ///   - shouldOriginal: 图标是否展示原色
    ///   - target:         响应目标
    ///   - selector:       响应事件
    convenience init(imageName: String, shouldOriginal: Bool = true, target: Any, selector: Selector) {
        var image = UIImage(named: imageName)
        if (image == nil) { assert(true, "找不到导航栏按钮的图片 \(imageName)") }
        if (shouldOriginal) { image = image!.withRenderingMode(.alwaysOriginal) }
        self.init(image: image, style: .plain, target: target, action: selector)
    }
    
//    convenience init(title: String, titleColor: UIColor, target: Any, selector: Selector) {
//        let btn = UIButton(type: .custom)
//        btn.setTitle(title, for: .normal)
//        btn.setTitleColor(titleColor, for: .normal)
//        btn.sizeToFit()
//        btn.addTarget(target, action: selector, for: .touchUpInside)
//        self.init(customView: btn)
//    }
    
//    convenience init(imageName: String, target: Any, selector: Selector) {
//        let image = UIImage(named: imageName)
//        if (image == nil) { assert(true, "找不到导航栏按钮的图片 \(imageName)") }
//        let btn = UIButton(type: .custom)
//        btn.setImage(image, for: .normal)
//        btn.sizeToFit()
//        btn.addTarget(target, action: selector, for: .touchUpInside)
//        self.init(customView: btn)
//    }
    
}


// MARK: - UIViewController WrappedType
public extension TypeWrapperProtocol where WrappedType: UIViewController {
    /// 获取当前导航栏的高度，注意控制器需被PUSH至导航控制器，才能取得高度值
    /// - Returns: 导航栏的高度，获取失败则返回nil
    func getNavigationSize() -> CGSize? {
        return wrappedValue.navigationController?.navigationBar.frame.size
    }
        
    /// 设置导航栏背景色（通过设置纯色导航栏背景图片达到效果）
    /// 注意控制器需被PUSH至导航控制器，才能实现效果
    /// - Parameters:
    ///   - backgroundColor:    导航栏背景色，nil时表示透明
    ///   - titleColor:         导航栏标题颜色
    ///   - fontSize:           导航栏标题字体大小
    func setNavigationBar(backgroundColor: UIColor? = nil, titleColor: UIColor = .black, fontSize: CGFloat = 12) {
        var bgImage: UIImage? = nil
        if let bgColor = backgroundColor, let size = getNavigationSize() {
            bgImage = UIImage.moe.image(with: bgColor, size: size)
        }
        if let navBar = wrappedValue.navigationController?.navigationBar {
            navBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
                NSAttributedString.Key.foregroundColor: titleColor
            ]
            navBar.setBackgroundImage(bgImage, for: .default)
        }
    }
    
    /// 为导航栏添加返回按钮
    func navigationAddBackItem() {
        let backItemAction = #selector(UIViewController.navigationBackItemAction)
        let backItem = UIBarButtonItem(imageName: "nav_back", target: wrappedValue, selector: backItemAction)
        wrappedValue.navigationItem.leftBarButtonItem = backItem
    }
    
    /// 将控制器添加至导航栈中，并展示其界面
    /// - Parameters:
    ///   - viewController: 要展示的视图控制器
    ///   - animated:       转场过程是否启用动画，默认为true
    func push(viewController: UIViewController, animated: Bool = true) {
        guard let navCtrler = wrappedValue.navigationController else {
            MLog("当前控制器【\(wrappedValue.moe.clazzName)】未处于导航栈中，无法完成PUSH操作")
            return
        }
        navCtrler.pushViewController(viewController, animated: animated)
    }
    
    /// 模态呈现控制器，展示其界面。
    /// 通过「转场动画 + 控制器」形式实现的功能控件，都应该通过该方法呈现，而不是调用 `push(viewController: animated:)` 方法
    /// - Parameters:
    ///   - viewController: 要展示的视图控制器
    ///   - animated:       转场过程是否启用动画，默认为true
    ///   - completion:     转场动画执行完成后的回调闭包
    func present(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        wrappedValue.present(viewController, animated: animated, completion: completion)
    }
}


// MARK: - UIViewController Extension
extension UIViewController {
    /// 导航栏返回按钮响应事件
    @objc open func navigationBackItemAction() {
        UIApplication.shared.keyWindow?.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
}
