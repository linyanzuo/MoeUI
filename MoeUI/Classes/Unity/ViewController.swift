//
//  Created by Zed on 2019/7/18.
//  Copyright © 2019 www.moemone.com. All rights reserved.
//

import UIKit
import MoeCommon


/// 视图控制器基类
open class ViewController: UIViewController, ViewControllerUnity {
    /// 尝试获取置顶窗口，若失败则返回控制器根视图
    public var topView: UIView {
        get { return MWindow.top ?? self.view }
    }
    
    /// 自定义回调闭包，使用字典对参数及返回值进行包装，用于控制器间传值
    open var customCallback: ((Dictionary<String, Any?>?) -> Dictionary<String, Any?>?)?
    
    // MARK: - Life Cycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        MLog("【定位控制器】\(String(describing: self))")
        self.view.backgroundColor = UIColor.white
        
        setupNavigation()
        setupSubview()
        setupData()
    }
    
    /// 【统一规范】导航的初始化方法
    /// ---
    /// 该方法在`viewDidLoad`中被调用, 子类重写该方法, 完成控制器中"导航相关的初始化"工作
    /// * `navigationItem`的配置， 如标题, 返回按钮, 左右两侧按钮
    /// * 导航栏颜色配置, 如前景色, 背景色
    /// * 自定义导航栏配置, 如自定义背景, 上划颜色渐变效果, 上划导航栏消失效果等
    open func setupNavigation() {}

    /// 【统一规范】根视图及其直接子视图的初始化方法
    /// ---
    /// 该方法在`viewDidLoad`中被调用, 子类重写该方法, 实现控制器中"根视图", 以及"根视图的直接子视图"的初始化工作.
    /// 理论上控制器只负责根视图的初始化工作, 建议由根视图自行处理子视图的相关初始化
    /// * 通过IB方式关联的控件, 都在本方法中完成额外的样式配置工作, 如更新字体颜色, 标题内容等
    /// * 若视图不复杂时, 可以在控制器中完成对根视图的直接子视图的初始化工作, 建议使用懒加载方式加载子视图, 并在该方法的最后位置为子视图添加约束
    /// * 禁止在控制器中进行根视图的孙级子视图的初始化工作, 复杂子视图代码应抽取, 在独立的视图类中完成
    open func setupSubview() {}
    
    /// 【统一规范】数据的初始化方法
    /// ---
    /// 该方法在`viewDidLoad`中被执行, 子类重写该方法, 完成控制器加载后的数据初始化
    /// * 发起网络请求获取页面所需数据，建议将每个网络请求单独封装
    /// * 获取持久化存储的数据
    open func setupData() {}
}
