//
//  PageMenuConfiguration.swift
//  PageMenu
//
//  Created by Zed on 2019/5/16.
//
//  样式配置

import UIKit


public class PageMenuConfiguration: NSObject {
    open var menuHeight : CGFloat = 34.0
    open var menuMargin: CGFloat = 15.0
    open var menuItemWidth: CGFloat = 111.0
    open var selectionIndicatorHeight: CGFloat = 3.0
    open var scrollAnimationDurationOnMenuItemTap: Int = 500 // 毫秒
    open var selectionIndicatorColor: UIColor = UIColor.white
    open var selectedMenuItemLabelColor: UIColor = UIColor.white
    open var unselectedMenuItemLabelColor: UIColor = UIColor.lightGray
    open var scrollMenuBackgroundColor: UIColor = UIColor.black
    open var viewBackgroundColor: UIColor = UIColor.white
    
    /// `MenuView`底部分割线的颜色
    open var bottomMenuHairlineColor: UIColor = UIColor.white
    open var menuItemSeparatorColor: UIColor = UIColor.lightGray

    open var menuItemFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    open var menuItemSeparatorPercentageHeight: CGFloat = 0.2
    open var menuItemSeparatorWidth: CGFloat = 0.5
    open var menuItemSeparatorRoundEdges: Bool = false

    open var addBottomMenuHairline: Bool = true
    open var menuItemWidthBasedOnTitleTextWidth: Bool = false
    open var titleTextSizeBasedOnMenuItemWidth: Bool = false
    open var useMenuLikeSegmentedControl: Bool = false
    open var centerMenuItems: Bool = false
    open var enableHorizontalBounce: Bool = true
    open var hideTopMenuBar: Bool = false
}


/// 分页菜单配置
public struct PageMenuConfig {
    /// 菜单栏配置
    var menu: Menu
    /// 菜单项配置
    var item: Item
    
    public struct Menu {
        var height: CGFloat
    }
    
    public struct Item {
        var font: UIFont = UIFont.systemFont(ofSize: 15.0)
        
    }
}

