//
//  Created by Zed on 2019/7/17.
//  Copyright © 2019 www.moemone.com. All rights reserved.
//

/// **【统一规范】**协议
public protocol Unity {}


/// **控制器**统一规范协议
public protocol ViewControllerUnity: Unity {
    /// 【统一规范】导航的初始化方法
    /// ---
    /// 该方法在`viewDidLoad`中被调用, 子类重写该方法, 完成控制器中"导航相关的初始化"工作
    /// * `navigationItem`的配置， 如标题, 返回按钮, 左右两侧按钮
    /// * 导航栏颜色配置, 如前景色, 背景色
    /// * 自定义导航栏配置, 如自定义背景, 上划颜色渐变效果, 上划导航栏消失效果等
    func setupNavigation()
    
    /// 【统一规范】根视图及其直接子视图的初始化方法
    /// ---
    /// 该方法在`viewDidLoad`中被调用, 子类重写该方法, 实现控制器中"根视图", 以及"根视图的直接子视图"的初始化工作.
    /// 理论上控制器只负责根视图的初始化工作, 建议由根视图自行处理子视图的相关初始化
    /// * 通过IB方式关联的控件, 都在本方法中完成额外的样式配置工作, 如更新字体颜色, 标题内容等
    /// * 若视图不复杂时, 可以在控制器中完成对根视图的直接子视图的初始化工作, 建议使用懒加载方式加载子视图, 并在该方法的最后位置为子视图添加约束
    /// * 禁止在控制器中进行根视图的孙级子视图的初始化工作, 复杂子视图代码应抽取, 在独立的视图类中完成
    func setupSubview()
    
    /// 【统一规范】数据的初始化方法
    /// ---
    /// 该方法在`viewDidLoad`中被执行, 子类重写该方法, 完成控制器加载后的数据初始化
    /// * 发起网络请求获取页面所需数据，建议将每个网络请求单独封装
    /// * 获取持久化存储的数据
    func setupData()
}
extension ViewControllerUnity {
    func setupNavigation() {}
    func setupSubview() {}
    func setupData() {}
}


/// **视图**统一规范协议
public protocol ViewUnity: Unity {
    /// 【统一规范】子视图初始化方法
    /// ---
    /// 子类重写该方法, 实现视图中"子视图的初始化"工作
    /// * 如果通过IB加载视图, 则直接在`awakeFromNib`方法中完成初始化
    /// * 本方法只负责子视图的实例化配置, 约束操作在`setupConstraint`方法中完成
    /// * 使用"懒加载"创建的子视图，不需要在该方法中做初始化.
    func setupSubview()
    
    /// 【统一规范】子视图约束初始化方法
    /// 子类重写该方法, 实现视图中"子视图约束的初始化"工作, 方便纯代码结构时能清晰获取视图结构
    /// * 如果通过IB加载视图, 则直接在`awakeFromNib`方法中完成初始化
    /// * 使用"懒加载"创建的子视图，不需要在该方法中做初始化.
    func setupConstraint()
}
extension ViewUnity {
    func setupSubview() {}
    func setupConstraint() {}
}
