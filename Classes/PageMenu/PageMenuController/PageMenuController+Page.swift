//
//  PageMenuController+Page.swift
//  PageMenu
//
//  Created by Zed on 2019/5/23.
//
//  扩展 - 内容页面的处理

import UIKit


extension MoePageMenuController {
    /// 将指定索引的控制器视图, 添加到主界面
    func addControllerPageAtIndex(_ index: Int) {
        let currentControlelr = controllerArray[index]
        delegate?.willMoveToPage?(currentControlelr, index: index)
        
        let newController = controllerArray[index]
        newController.willMove(toParentViewController: self)
        /**
         * 解决`addChild(newController)`后, `newController.view`的宽高变成2倍大小的问题
            1. 该问题由`childVC.view.autoresizingMask`导致, 默认为宽高`flexible`(可伸缩, 随容器而变化).
            2. 如果先设置容器的`frame`, 则子视图添加后宽高随容器而延伸, 值为准确的`frame`
            3. 如果先设置了`childVC.view`的`frame`后再设置容器的`frame`, 则子视图添加后会在原宽高基础上进行"延伸", 值为`frame`的两倍
         */
        newController.view.autoresizingMask = []
        newController.view.frame = CGRect(x: view.frame.width * CGFloat(index),
                                          y: configuration.menuHeight,
                                          width: view.frame.width,
                                          height: view.frame.height - configuration.menuHeight)
        addChildViewController(newController)
        controllerView.addSubview(newController.view)
        newController.didMove(toParentViewController: self)
    }
    
    /// 从当前页移动到指定索引对应的页
    func moveToControllerPage(_ pageIndex: Int) {
        if pageIndex < 0 || pageIndex >= controllerArray.count { return }
        
        if pageIndex != currentPageIndex {
            lastPageIndex = currentPageIndex
            currentPageIndex = pageIndex
            startingPageForScroll = pageIndex
            isTapMenuItemToScroll = true
            
            // 如果需要, 在当前页与点击目标页之间添加新页面
            let smallerIndex: Int = lastPageIndex < currentPageIndex ? lastPageIndex : currentPageIndex
            let largeIndex: Int = lastPageIndex > currentPageIndex ? lastPageIndex : currentPageIndex
            if smallerIndex + 1 != largeIndex {
                for i in (smallerIndex + 1)...(largeIndex - 1) {
                    if pagesAddedDictionary[i] != i {
                        addControllerPageAtIndex(i)
                        pagesAddedDictionary[i] = i
                    }
                }
            }
            
            addControllerPageAtIndex(pageIndex)
            pagesAddedDictionary[lastPageIndex] = lastPageIndex
        }
        
        // 执行移动的动画
        let duration = Double(configuration.scrollAnimationDurationOnMenuItemTap) / Double(1000)
        UIView.animate(withDuration: duration) {
            let xOffset = CGFloat(pageIndex) * self.controllerView.frame.width
            self.controllerView.setContentOffset(
                CGPoint(x: xOffset, y: self.controllerView.contentOffset.y),
                animated: false)
        }
    }
    
    /// 移除指定索引位置的页面
    func removeControllerPageAtIndex(_ index: Int) {
        let oldController = controllerArray[index]
        oldController.willMove(toParentViewController: nil)
        oldController.view.removeFromSuperview()
        oldController.removeFromParentViewController()
        oldController.didMove(toParentViewController: nil)
    }
    
    /// 移动指示器至选中标签项
    func moveSelectionIndicator(_ pageIndex: Int) {
        if pageIndex < 0 || pageIndex >= controllerArray.count { return }
        
        UIView.animate(withDuration: 0.15) {
            var selectionIndicatorWidth: CGFloat = self.selectionIndicatorView.frame.width
            var selectionIndicatorX: CGFloat = 0.0
            let pageCount = CGFloat(self.controllerArray.count)
            
            if self.configuration.useMenuLikeSegmentedControl {
                selectionIndicatorX = CGFloat(pageIndex) * self.view.frame.width / pageCount
                selectionIndicatorWidth = self.view.frame.width / pageCount
            }
            else if self.configuration.menuItemWidthBasedOnTitleTextWidth {
                selectionIndicatorWidth = self.menuItemWidths[pageIndex]
                selectionIndicatorX += self.configuration.menuMargin
                if pageIndex >= 1 {
                    for i in 0...(pageIndex - 1) {
                        selectionIndicatorX += (self.configuration.menuMargin + self.menuItemWidths[i])
                    }
                }
            }
            else {
                if self.configuration.centerMenuItems && pageIndex == 0 {
                    selectionIndicatorX = self.startingMenuMargin + self.configuration.menuMargin
                } else {
                    selectionIndicatorX = self.configuration.menuItemWidth * CGFloat(pageIndex)
                        + self.configuration.menuMargin * CGFloat(pageIndex + 1) + self.startingMenuMargin
                }
            }
            
            self.selectionIndicatorView.frame = CGRect(x: selectionIndicatorX,
                                                       y: self.selectionIndicatorView.frame.origin.y,
                                                       width: selectionIndicatorWidth,
                                                       height: self.selectionIndicatorView.frame.size.height)
            
            self.menuItems[self.lastPageIndex].titleLabel.textColor = self.configuration.unselectedMenuItemLabelColor
            self.menuItems[self.currentPageIndex].titleLabel.textColor = self.configuration.selectedMenuItemLabelColor
        }
    }
    
    /// 重新布局子视图
    override open func viewDidLayoutSubviews() {
        let pageCount = CGFloat(controllerArray.count)
        // 重新配置scrollView的contentSize
        controllerView.contentSize = CGSize(width: view.frame.width * pageCount,
                                            height: self.view.frame.height - configuration.menuHeight)
        
        let oldCurrentOrientationIsPortrait: Bool = currentOrientationIsPortrait
        if UIDevice.current.orientation != UIDeviceOrientation.unknown {
            currentOrientationIsPortrait = UIDevice.current.orientation.isPortrait || UIDevice.current.orientation.isFlat
        }
        let isPortraitToLandscape = oldCurrentOrientationIsPortrait && UIDevice.current.orientation.isLandscape
        let isLandscapeToPortrait = !oldCurrentOrientationIsPortrait && (UIDevice.current.orientation.isPortrait || UIDevice.current.orientation.isFlat)
        
        // 屏幕方向切换时的处理 (横->竖 || 竖->横)
        if (isPortraitToLandscape || isLandscapeToPortrait) {
            didLayoutSubviewsAfterRotation = true
            
            // 重新调整menuView
            if configuration.useMenuLikeSegmentedControl {
                menuView.contentSize = CGSize(width: view.frame.width, height: configuration.menuHeight)
                
                // 重新调整选中指示器的尺寸
                let selectionIndicatorX: CGFloat = CGFloat(currentPageIndex) * (view.frame.width / pageCount)
                let selectionIndicatorWidth: CGFloat = view.frame.width / pageCount
                selectionIndicatorView.frame =  CGRect(x: selectionIndicatorX,
                                                       y: selectionIndicatorView.frame.origin.y,
                                                       width: selectionIndicatorWidth,
                                                       height: selectionIndicatorView.frame.height)
                
                // 重新调整menuItem的尺寸
                var index: Int = 0
                for item: PageMenuItem in menuItems {
                    item.frame = CGRect(x: view.frame.width / pageCount * CGFloat(index),
                                        y: 0.0,
                                        width: view.frame.width / pageCount,
                                        height: configuration.menuHeight)
                    item.titleLabel.frame = CGRect(x: 0.0,
                                                    y: 0.0,
                                                    width: view.frame.width / pageCount,
                                                    height: configuration.menuHeight)
                    item.menuItemSeparator!.frame = CGRect(x: item.frame.width - (configuration.menuItemSeparatorWidth / 2),
                                                           y: item.menuItemSeparator!.frame.origin.y,
                                                           width: item.menuItemSeparator!.frame.width,
                                                           height: item.menuItemSeparator!.frame.height)
                    index += 1
                }
            }
            else if configuration.centerMenuItems {
                startingMenuMargin = (
                    (view.frame.width - pageCount * configuration.menuItemWidth)
                    + (pageCount - 1) * configuration.menuMargin
                ) / 2.0 -  configuration.menuMargin
                
                if startingMenuMargin < 0.0 { startingMenuMargin = 0.0 }
                
                // 重新调整选中指示器的尺寸
                let selectionIndicatorX: CGFloat = configuration.menuItemWidth * CGFloat(currentPageIndex) + configuration.menuMargin * CGFloat(currentPageIndex + 1) + startingMenuMargin
                selectionIndicatorView.frame =  CGRect(x: selectionIndicatorX,
                                                       y: selectionIndicatorView.frame.origin.y,
                                                       width: selectionIndicatorView.frame.width,
                                                       height: selectionIndicatorView.frame.height)
                
                // 重新调整menuItem的尺寸
                var index : Int = 0
                for item : PageMenuItem in menuItems {
                    if index == 0 {
                        item.frame = CGRect(x: startingMenuMargin + configuration.menuMargin,
                                            y: 0.0,
                                            width: configuration.menuItemWidth,
                                            height: configuration.menuHeight)
                    } else {
                        item.frame = CGRect(x: configuration.menuItemWidth * CGFloat(index) + configuration.menuMargin * CGFloat(index + 1) + startingMenuMargin,
                                            y: 0.0,
                                            width: configuration.menuItemWidth,
                                            height: configuration.menuHeight)
                    }
                    index += 1
                }
            }
            
            // 重新配置controllerView的子视图frame值
            for view in controllerView.subviews {
                view.frame = CGRect(x: view.frame.width * CGFloat(self.currentPageIndex),
                                    y: configuration.menuHeight,
                                    width: controllerView.frame.width,
                                    height: view.frame.height - configuration.menuHeight)
            }
            
            let xOffset: CGFloat = CGFloat(currentPageIndex) * controllerView.frame.width
            controllerView.setContentOffset(CGPoint(x: xOffset, y: controllerView.contentOffset.y), animated: false)
            
            let ratio : CGFloat = (menuView.contentSize.width - view.frame.width) / (controllerView.contentSize.width - view.frame.width)
            if menuView.contentSize.width > view.frame.width {
                var offset : CGPoint = menuView.contentOffset
                offset.x = controllerView.contentOffset.x * ratio
                menuView.setContentOffset(offset, animated: false)
            }
        }
        
        view.layoutIfNeeded()
    }
}
