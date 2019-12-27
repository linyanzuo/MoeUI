//
//  ViewControllerUnity.swift
//  MoeUI
//
//  Created by Zed on 2019/9/3.
//

import UIKit


open class UnitedViewController: UIViewController, ViewControllerUnity {
    open override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupViews()
        setupViewConstraints()
        setupRequest()
    }

    /// 统一编程规范: 导航配置的初始化
    /// ---
    /// 该方法在`viewDidLoad`中被执行, 子类重写该方法, 完成控制器中"导航相关的初始化"工作
    /// * `navigationItem`的配置， 如标题, 返回按钮, 左右两侧按钮
    /// * 导航栏颜色配置, 如前景色, 背景色
    /// * 自定义导航栏配置, 如自定义背景, 上划颜色渐变效果, 上划导航栏消失效果等
    open func setupNavigation() {}

    /// 统一编程规范: 视图的初始化
    /// ---
    /// 该方法在`viewDidLoad`中被执行, 子类重写该方法, 为控制器添加视图 理论上控制器只负责根视图的初始化工作, 建议由根视图类自行处理子视图的相关初始化
    /// * 通过IB方式关联的控件, 都在本方法中完成额外的样式配置工作, 如更新字体颜色, 标题内容等
    /// * 若视图不复杂时, 可以在控制器中完成对根视图的直接子视图的初始化工作, 建议使用懒加载方式加载子视图
    /// * 禁止在控制器中进行根视图的孙级子视图的初始化工作, 复杂子视图代码应抽取, 在独立的视图类中完成
    open func setupViews() {}

    /// 统一编程规范: 视图约束的初始化
    /// ---
    /// 该方法在`viewDidLoad`中被执行, 子类重写该方法, 为控制器中的视图添加约束. 理论上控制器只负责根视图的初始化工作, 建议由根视图类自行处理子视图的相关初始化
    open func setupViewConstraints() {}

    /// 统一编程规范: 若控制器加载后有网络数据请求, 则在本方法中完成
    /// ---
    /// 该方法在`viewDidLoad`中被执行, 子类重写该方法, 完成控制器加载后的网线请求处理
    /// * 若控制器包含多个网络请求, 建议每个请求都写成独立方法, 在本方法中调用各个请求.
    open func setupRequest() {}
}
