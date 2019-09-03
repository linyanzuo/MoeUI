//
//  BaseView.swift
//  MoeUI
//
//  Created by Zed on 2019/9/3.
//

import UIKit


/// UIView programming unity standard
protocol ViewUnity: Unity where Self: UIView  {
    func setupSubview()
    func setupConstraint()
}
extension ViewUnity {
    /// 统一编程规范: 子视图初始化方法
    /// ---
    /// 子类重写该方法, 实现视图中"子视图的初始化"工作
    /// * 如果通过IB加载视图, 则直接在`awakeFromNib`方法中完成初始化
    /// * 本方法只负责子视图的实例化配置, 约束操作在`setupConstraint`方法中完成
    /// * 建议使用"懒加载+约束"的结构进行子视图初始化.
    func setupSubview() {}

    /// 统一编程规范: 子视图约束初始化方法
    /// 子类重写该方法, 实现视图中"子视图约束的初始化"工作, 方便纯代码结构时能清晰获取视图结构
    /// * 如果通过IB加载视图, 则直接在`awakeFromNib`方法中完成初始化
    /// * 建议使用"懒加载+约束"的结构进行子视图初始化.
    func setupConstraint() {}
}


class BaseView: UIView, ViewUnity {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
        setupConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubview()
        setupConstraint()
    }
}
