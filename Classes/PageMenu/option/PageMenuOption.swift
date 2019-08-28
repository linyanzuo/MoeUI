//
//  PageMenuOption.swift
//  PageMenu
//
//  Created by Zed on 2019/5/20.
//
//  样式配置 - 参数枚举

import UIKit


public enum PageMenuOption {
    // MARK: 列表视图配置
    case viewBackgroundColor(UIColor)
    case scrollMenuBackgroundColor(UIColor)
    case menuHeight(CGFloat)
    case menuMargin(CGFloat)

    case addBottomMenuHairline(Bool)
    case bottomMenuHairlineColor(UIColor)

    // MARK: 列表项配置
    case menuItemWidth(CGFloat)
    case menuItemMargin(CGFloat)
    case menuItemFont(UIFont)
    case selectedMenuItemLabelColor(UIColor)
    case unselectedMenuItemLabelColor(UIColor)

    // MARK: 分割线配置
    case menuItemSeparatorWidth(CGFloat)
    case menuItemSeparatorPercentageHeight(CGFloat)
    case menuItemSeparatorColor(UIColor)
    case menuItemSeparatorRoundEdges(Bool)

    // MARK: 选中指示器配置
    case selectionIndicatorHeight(CGFloat)
    case selectionIndicatorColor(UIColor)

    // MARK: 其它配置
    case menuItemWidthBasedOnTitleTextWidth(Bool)
    case titleTextSizeBasedOnMenuItemWidth(Bool)

    case enableHorizontalBounce(Bool)
    case scrollAnimationDurationOnMenuItemTap(Int)

    case centerMenuItems(Bool)
    case hideTopMenuBar(Bool)

    case useMenuLikeSegmentedControl(Bool)
}

