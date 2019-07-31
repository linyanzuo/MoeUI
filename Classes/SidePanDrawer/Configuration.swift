//
//  Configuration.swift
//  MoeUI
//
//  Created by Zed on 2019/7/31.
//
//  转场动画相关的配置参数

import UIKit


public struct Configuration {
    public enum PanDirection {
        case fromLeft
        case fromRight
    }

    /// 侧滑偏移距离占屏幕宽度的百分比
    public var distancePercent: CGFloat = 0.75
    /// 手势触发的临界点比例, 达到临界点则触发完成
    public var criticalPointPercent: CGFloat = 0.5

    /// 展现时的动画时长
    public var presentAnimationDuration: Double = 0.25
    /// 消失时的动画时长
    public var dismissAnimationDuration: Double = 0.25

    /// y轴的视图缩放比例
    public var viewScaleY: CGFloat = 1.0
    /// 侧滑的方向
    public var panDirection: PanDirection = .fromLeft
    /// 动画过程的背景图片
    public var backgroundImage: UIImage?
    /// 遮罩的透明度
    public var maskViewAlpha: CGFloat = 0.4

    public init() {}
}
