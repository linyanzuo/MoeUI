//
//  BaseView.swift
//  MoeUI
//
//  Created by Zed on 2019/9/3.
//

import UIKit


/// UnitedView
open class UnitedView: UIView, ViewUnity {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }

    /// 统一编程规范: 视图初始化方法
    /// ---
    /// 子类重写该方法, 实现"视图自身的初始化"工作
    /// * 如果通过IB加载视图, 则直接在`awakeFromNib()`方法中完成剩余的视图初始化
    public func setupSelf() {}

    /// 统一编程规范: 子视图初始化方法
    /// ---
    /// 子类重写该方法, 实现"子视图的初始化"工作
    /// * 本方法负责子视图的实例创建、配置修改、添加至父视图等
    /// * 约束操作请在`setupConstraints`方法中完成
    /// * 通过IB加载的视图, 可不必实现本方法
    /// * 若使用"懒加载+约束"的结构，可不必实现本方法
    open func setupSubviews() {}

    /// 统一编程规范: 视图约束初始化方法
    /// ---
    /// 子类重写该方法, 实现视图中"子视图约束的初始化"工作
    /// * 方便纯代码结构时能清晰获取视图结构
    /// * 通过IB加载的视图，若有约束变更，则直接在`awakFromNib()`方法中完成
    /// * 建议使用"懒加载+约束"的结构进行子视图初始化.
    open func setupConstraints() {}
}
