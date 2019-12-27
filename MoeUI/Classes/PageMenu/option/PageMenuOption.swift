//
//  PageMenuOption.swift
//  PageMenu
//
//  Created by Zed on 2019/5/20.
//
//  样式配置 - 参数枚举

import UIKit


/// 分页菜单配置
public enum PageMenuOption {
    
    // MARK: 菜单栏配置
    
    /// 无实际使用, 待删除
    case viewBackgroundColor(UIColor)
    /// 菜单栏的背景色
    case scrollMenuBackgroundColor(UIColor)
    /// 菜单栏的高度
    case menuHeight(CGFloat)
    /// 菜单栏内每个菜单项之间的间距, 关闭`useMenuLikeSegmentedControl`时才生效
    case menuMargin(CGFloat)

    /// 是否为菜单栏底部添加细线
    case addBottomMenuHairline(Bool)
    /// 菜单栏底部细线的颜色
    case bottomMenuHairlineColor(UIColor)

    // MARK: 菜单项配置
    
    case menuItemWidth(CGFloat)
    /// 菜单项的内边距, 即文字在视图中的内缩进, 该属性有问题
    case menuItemMargin(CGFloat)
    /// 菜单项的字体
    case menuItemFont(UIFont)
    /// 选中菜单项的文字颜色
    case selectedMenuItemLabelColor(UIColor)
    /// 未选中菜单项的文字颜色
    case unselectedMenuItemLabelColor(UIColor)

    // MARK: 分割线配置
    
    /// 菜单项间分割线的宽度
    case menuItemSeparatorWidth(CGFloat)
    /// 菜单项间分割线的百分比高度
    case menuItemSeparatorPercentageHeight(CGFloat)
    /// 菜单项间分割线的颜色
    case menuItemSeparatorColor(UIColor)
    /// 菜单项间分割线的边缘圆角
    case menuItemSeparatorRoundEdges(Bool)

    // MARK: 选中指示器配置
    
    /// 选中指示器的高度
    case selectionIndicatorHeight(CGFloat)
    /// 选中指示器的颜色
    case selectionIndicatorColor(UIColor)

    // MARK: 其它配置
    
    /// 根据菜单项的文本内容, 自适应宽度
    case menuItemWidthBasedOnTitleTextWidth(Bool)
    /// 根据菜单栏的尺寸, 自适应菜单项的尺寸
    case titleTextSizeBasedOnMenuItemWidth(Bool)

    /// 分页页面是否支持`边缘拖拽的弹性效果`
    case enableHorizontalBounce(Bool)
    /// 分页页面切换时的动画时间
    case scrollAnimationDurationOnMenuItemTap(Int)
    
    case centerMenuItems(Bool)
    /// 隐藏菜单栏
    case hideTopMenuBar(Bool)

    /// 类似`UISegmentControl`的样式, 菜单项的宽度将自动计算
    case useMenuLikeSegmentedControl(Bool)
}

