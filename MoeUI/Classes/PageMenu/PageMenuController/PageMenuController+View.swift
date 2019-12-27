//
//  PageMenuController+Option.swift
//  PageMenu
//
//  Created by Zed on 2019/5/20.
//
//  扩展 - 视图的加载配置

import UIKit


extension MoePageMenuController {
    /// 将`PageMenuOption`的值转化成`PageMenuController`中相应的`configuration`
    func configurePageMenu(options: [PageMenuOption]) {
        for option in options {
            switch (option) {
            // 列表视图配置
            case let .viewBackgroundColor(value):
                configuration.viewBackgroundColor = value
            case let .scrollMenuBackgroundColor(value):
                configuration.scrollMenuBackgroundColor = value
            case let .menuHeight(value):
                configuration.menuHeight = value
            case let .menuMargin(value):
                configuration.menuMargin = value
            case let .addBottomMenuHairline(value):
                configuration.addBottomMenuHairline = value
            case let .bottomMenuHairlineColor(value):
                configuration.bottomMenuHairlineColor = value
            // 列表项配置
            case let .menuItemWidth(value):
                configuration.menuItemWidth = value
            case let .menuItemMargin(value):
                menuItemMargin = value
            case let .menuItemFont(value):
                configuration.menuItemFont = value
            case let .selectedMenuItemLabelColor(value):
                configuration.selectedMenuItemLabelColor = value
            case let .unselectedMenuItemLabelColor(value):
                configuration.unselectedMenuItemLabelColor = value
            // 分割线配置
            case let .menuItemSeparatorWidth(value):
                configuration.menuItemSeparatorWidth = value
            case let .menuItemSeparatorPercentageHeight(value):
                configuration.menuItemSeparatorPercentageHeight = value
            case let .menuItemSeparatorColor(value):
                configuration.menuItemSeparatorColor = value
            case let .menuItemSeparatorRoundEdges(value):
                configuration.menuItemSeparatorRoundEdges = value
            // 选中指示器配置
            case let .selectionIndicatorHeight(value):
                configuration.selectionIndicatorHeight = value
            case let .selectionIndicatorColor(value):
                configuration.selectionIndicatorColor = value
            // 其它配置
            case let .menuItemWidthBasedOnTitleTextWidth(value):
                configuration.menuItemWidthBasedOnTitleTextWidth = value
            case let .titleTextSizeBasedOnMenuItemWidth(value):
                configuration.titleTextSizeBasedOnMenuItemWidth = value
            case let .enableHorizontalBounce(value):
                configuration.enableHorizontalBounce = value
            case let .scrollAnimationDurationOnMenuItemTap(value):
                configuration.scrollAnimationDurationOnMenuItemTap = value
            case let .centerMenuItems(value):
                configuration.centerMenuItems = value
            case let .hideTopMenuBar(value):
                configuration.hideTopMenuBar = value
            case let .useMenuLikeSegmentedControl(value):
                configuration.useMenuLikeSegmentedControl = value
            }
        }
        
        // 隐藏顶部列表栏的配置
        if configuration.hideTopMenuBar {
            configuration.addBottomMenuHairline = false
            configuration.menuHeight = 0.0
        }
    }
    
    /** 加载子视图 */
    func setupSubview() {
        view.backgroundColor = configuration.scrollMenuBackgroundColor
        setupControllerView()
        setupMenuView()
    }
 
    /** 根据configuration配置UI视图, 并添加手势, 滚动等 */
    func configureUserInterface() {
        /**
         当`scrollsToTop`为true, `shouldScrollViewScrollToTop`代理方法没有返回false, scrollView并没有滚动至最顶内容时
         一旦用户点击状态栏, 最靠近状态栏的scrollView会滚动至最顶内容
         禁用`menuView`和`controllereView`的scrollsToTop, 此时点击状态栏, iOS就会找到页面内容(controllerView中的每个子页)中的scrollView来滚动至最顶
         */
        menuView.scrollsToTop = false
        controllerView.scrollsToTop = false
        
        // 配置`controllerView`
        controllerView.delegate = self
        
        // 配置`menuView`
        if configuration.useMenuLikeSegmentedControl {
            // 作为segment使用时, 不可滚动, 无外边距
            menuView.isScrollEnabled = false
            menuView.contentSize = CGSize(width: view.frame.width, height: configuration.menuHeight)
            configuration.menuMargin = 0
        } else {
            let width: CGFloat = (configuration.menuItemWidth + configuration.menuMargin) * CGFloat(controllerArray.count) + configuration.menuMargin
            menuView.contentSize = CGSize(width: width,height: configuration.menuHeight)
        }
        
        // 为`menuView`添加响应事件, 用来识别`menu item`的选择
        let menuItemTap = UITapGestureRecognizer(target: self, action: #selector(MoePageMenuController.menuItemTapAction(_:)))
        menuItemTap.numberOfTapsRequired = 1
        menuItemTap.numberOfTouchesRequired = 1
        menuItemTap.delegate = self
        menuView.addGestureRecognizer(menuItemTap)
        
        // 为`menuView`添加`menuItem`
        configItemForMenuView()
        
        // 检查是否需要重新设置`menuView`的contentSize
        if configuration.menuItemWidthBasedOnTitleTextWidth {
            menuView.contentSize = CGSize(width: (totalMenuItemWidthIfDifferentWidths + configuration.menuMargin) + CGFloat(controllerArray.count) * configuration.menuMargin, height: configuration.menuHeight)
        }
        else if configuration.menuItemWidthBasedOnTitleTextWidth {
            menuView.contentSize = CGSize(width: (totalMenuItemWidthIfDifferentWidths + configuration.menuMargin) + CGFloat(controllerArray.count) * configuration.menuMargin, height: configuration.menuHeight)
        }
        
        // 配置选中`menuItem`样式
        if menuItems.count > 0 {
            menuItems[currentPageIndex].titleLabel.textColor = configuration.selectedMenuItemLabelColor
        }
        
        // 配置选中指示器
        setupIndicator()
    }
    
    // MARK: Private Method
    
    /** 初始化 menuView */
    private func setupMenuView() {
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: configuration.menuHeight)
        menuView.backgroundColor = configuration.scrollMenuBackgroundColor
        view.addSubview(menuView)
        
        let menuView_constraint_H:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:|[menuView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["menuView" : menuView])
        let menuView_constraint_V:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:[menuView(\(configuration.menuHeight))]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["menuView" : menuView])
        view.addConstraints(menuView_constraint_H)
        view.addConstraints(menuView_constraint_V)
        
        // 为menuView添加底部细线
        if configuration.addBottomMenuHairline {
            let menuBottomHairLine: UIView = UIView()
            menuBottomHairLine.translatesAutoresizingMaskIntoConstraints = false
            menuBottomHairLine.backgroundColor = configuration.bottomMenuHairlineColor
            view.addSubview(menuBottomHairLine)

            // 底部阴影
//            menuView.layer.shadowPath = UIBezierPath(rect: menuView.bounds).cgPath
//            menuView.layer.shadowColor = configuration.bottomMenuHairlineColor.cgColor
//            menuView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//            menuView.layer.shadowOpacity = 0.5
//            menuView.layer.masksToBounds = false

            let menuBottomHairline_constraint_H:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:|[menuBottomHairline]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["menuBottomHairline":menuBottomHairLine])
            let menuBottomHairline_constraint_V:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(configuration.menuHeight)-[menuBottomHairline(0.5)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["menuBottomHairline":menuBottomHairLine])
            view.addConstraints(menuBottomHairline_constraint_H)
            view.addConstraints(menuBottomHairline_constraint_V)
        }
    }
    
    /** 为menuView 配置 menuItem */
    private func configItemForMenuView() {
        var index: CGFloat = 0.0
        let pageCount: CGFloat = CGFloat(controllerArray.count)
        
        for controller in controllerArray {
            if index == 0.0 {
                controller.viewWillAppear(true)
                addControllerPageAtIndex(0)
//                controller.viewDidAppear(true)
            }
            
            // 计算`menuItem`的frame值
            var menuItemFrame: CGRect = CGRect.zero
            // 作为segment展示时, menuItem固定size
            if configuration.useMenuLikeSegmentedControl {
                if menuItemMargin > 0 {
                    let marginSum = menuItemMargin * (pageCount + 1)
                    let menuItemWidth = (view.frame.width - marginSum) / pageCount
                    menuItemFrame = CGRect(x: CGFloat(menuItemMargin * (index + 1) + menuItemWidth * CGFloat(index)),
                                           y: 0.0,
                                           width: view.frame.width,
                                           height: configuration.menuHeight)
                }
                else {
                    menuItemFrame = CGRect(x: view.frame.width / pageCount * CGFloat(index),
                                           y: 0.0,
                                           width: view.frame.width,
                                           height: configuration.menuHeight)
                }
            }
            // 配置baseOnTitle时, `menuItem`宽度取决于标题大小
            else if configuration.menuItemWidthBasedOnTitleTextWidth {
                let itemTitle: String = controller.title ?? "Menu \(index + 1)"
                let titleRect: CGRect = (itemTitle as NSString).boundingRect(
                    with: CGSize(width: CGFloat(MAXFLOAT), height: configuration.menuHeight),
                    options: .usesLineFragmentOrigin,
                    attributes: [NSAttributedString.Key.font : configuration.menuItemFont],
                    context: nil)
                menuItemFrame = CGRect(x: configuration.menuMargin + totalMenuItemWidthIfDifferentWidths + configuration.menuMargin * index,
                                       y: 0.0,
                                       width: titleRect.width,
                                       height: configuration.menuHeight)
                
                configuration.menuItemWidth = titleRect.width
                totalMenuItemWidthIfDifferentWidths += titleRect.width
                menuItemWidths.append(titleRect.width)
            }
            // 普通`menuItem`
            else {
                if configuration.centerMenuItems && index == 0.0 {
                    startingMenuMargin = (view.frame.width - pageCount * configuration.menuItemWidth - (pageCount - 1) * configuration.menuMargin) / 2.0 - configuration.menuMargin
                    if startingMenuMargin < 0.0 {
                        startingMenuMargin = 0.0
                    }
                    
                    menuItemFrame = CGRect(x: startingMenuMargin + configuration.menuMargin,
                                           y: 0.0,
                                           width: configuration.menuItemWidth,
                                           height: configuration.menuHeight)
                }
                else {
                    menuItemFrame = CGRect(x: configuration.menuItemWidth * index + configuration.menuMargin * (index + 1) + startingMenuMargin,
                                           y: 0.0,
                                           width: configuration.menuItemWidth,
                                           height: configuration.menuHeight)
                }
            }
            
            // 创建`menuItem`并添加至`menuView`
            // Todo: 使用临时PageMenuItemOption配置, 待验证
            let option = PageMenuItemOption()
            let menuItem = PageMenuItem(frame: menuItemFrame, option: option)
            menuItem.configure(for: self, controller: controller, index: index)
            menuView.addSubview(menuItem)
            menuItems.append(menuItem)
            
            index += 1
        }
    }
    
    /** 初始化 controllerView */
    private func setupControllerView() {
        controllerView.isPagingEnabled = true
        controllerView.translatesAutoresizingMaskIntoConstraints = false
        controllerView.alwaysBounceHorizontal = configuration.enableHorizontalBounce
        controllerView.bounces = configuration.enableHorizontalBounce
        controllerView.showsHorizontalScrollIndicator = false
        controllerView.showsVerticalScrollIndicator = false
        view.addSubview(controllerView)
        
        let controllerView_constraint_H:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:|[controllerView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["controllerView" : controllerView])
        let controllerView_constraint_V:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:|[controllerView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["controllerView" : controllerView])
        view.addConstraints(controllerView_constraint_H)
        view.addConstraints(controllerView_constraint_V)
    }
    
    /** 初始化 indicator */
    private func setupIndicator() {
        var indicatorFrame = CGRect.zero
        let pageCount: CGFloat = CGFloat(controllerArray.count)
        
        if configuration.useMenuLikeSegmentedControl {
            indicatorFrame = CGRect(x: 0.0,
                                    y: configuration.menuHeight - configuration.selectionIndicatorHeight,
                                    width: view.frame.width / pageCount,
                                    height: configuration.selectionIndicatorHeight)
        } else if configuration.menuItemWidthBasedOnTitleTextWidth {
            indicatorFrame = CGRect(x: configuration.menuMargin,
                                    y: configuration.menuHeight - configuration.selectionIndicatorHeight,
                                    width: menuItemWidths[0],
                                    height: configuration.selectionIndicatorHeight)
        } else {
            if configuration.centerMenuItems {
                indicatorFrame = CGRect(x: startingMenuMargin + configuration.menuMargin,
                                        y: configuration.menuHeight - configuration.selectionIndicatorHeight,
                                        width: configuration.menuItemWidth,
                                        height: configuration.selectionIndicatorHeight)
            }
        }
        
        selectionIndicatorView = UIView(frame: indicatorFrame)
        selectionIndicatorView.backgroundColor = configuration.selectionIndicatorColor
        menuView.addSubview(selectionIndicatorView)
    }
}

