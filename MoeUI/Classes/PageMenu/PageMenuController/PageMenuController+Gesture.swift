//
//  PageMenuController+Gesture.swift
//  PageMenu
//
//  Created by Zed on 2019/5/23.
//
//  扩展 - 手势处理

import UIKit


extension MoePageMenuController: UIGestureRecognizerDelegate {
    /// menuItem的单击事件处理
    @objc public func menuItemTapAction(_ tap: UITapGestureRecognizer) {
        let tappedPoint = tap.location(in: menuView)
        if tappedPoint.y > menuView.frame.height { return }
        
        // 计算出被点击的menuItem的索引值
        var itemIndex: Int = 0

        if configuration.useMenuLikeSegmentedControl {
            // Segment模式, item宽度一致
            let itemWidth = view.frame.width / CGFloat(controllerArray.count)
            itemIndex = Int(tappedPoint.x / itemWidth)
        }
        else if configuration.menuItemWidthBasedOnTitleTextWidth {
            // 适配标题模式, item宽度不一, 从第一个item开始检查
            var menuItemLeftBound: CGFloat = 0.0
            var menuItemRightBound: CGFloat = configuration.menuMargin + menuItemWidths[0] + (configuration.menuMargin / 2)
            
            if !(menuItemLeftBound <= tappedPoint.x && tappedPoint.x < menuItemRightBound) {
                // 逐个检查, 直到找到匹配的item为止
                for i in 1...controllerArray.count - 1 {
                    menuItemLeftBound = menuItemRightBound + 1.0
                    menuItemRightBound = menuItemLeftBound + menuItemWidths[i] + configuration.menuMargin
                    
                    // 找到匹配的item
                    if (menuItemLeftBound <= tappedPoint.x && tappedPoint.x < menuItemRightBound) {
                        itemIndex = i
                        break
                    }
                }
            }
        }
        else {
            let rawItemIndex: CGFloat = ((tappedPoint.x - startingMenuMargin) - configuration.menuMargin / 2) / (configuration.menuMargin + configuration.menuItemWidth)
            
            // 点击第一个item左侧时, 阻止移动到第一个项目的操作
            if rawItemIndex < 0 {
                itemIndex = -1
            } else {
                itemIndex = Int(rawItemIndex)
            }
        }
        
        // 检查是否需要更新controllerView
        if !(0 <= itemIndex && itemIndex < controllerArray.count) { return }
        
        // 需要更新页面
        if itemIndex != currentPageIndex {
            startingPageForScroll = itemIndex
            lastPageIndex = currentPageIndex
            currentPageIndex = itemIndex
            isTapMenuItemToScroll = true
            
            // 如果需要, 在当前页与点击目标页间添加页面
            let smallerIndex : Int = lastPageIndex < currentPageIndex ? lastPageIndex : currentPageIndex
            let largerIndex : Int = lastPageIndex > currentPageIndex ? lastPageIndex : currentPageIndex
            if smallerIndex + 1 != largerIndex {
                for index in (smallerIndex + 1)...(largerIndex - 1) {
                    if pagesAddedDictionary[index] != index {
                        addControllerPageAtIndex(index)
                        pagesAddedDictionary[index] = index
                    }
                }
            }
            
            addControllerPageAtIndex(itemIndex)
            pagesAddedDictionary[lastPageIndex] = lastPageIndex
        }
        // 执行页面切换动画
        let duration = Double(configuration.scrollAnimationDurationOnMenuItemTap) / Double(1000)
        UIView.animate(withDuration: duration) {
            let xOffset = CGFloat(itemIndex) * self.controllerView.frame.width
            self.controllerView.setContentOffset(CGPoint(x: xOffset, y: self.controllerView.contentOffset.y),
                                                 animated: false)
        }
        
        // 手动触发controllerView结束拖拽后的处理(页面移动, 代理通知)
        if tapTimer != nil {
            tapTimer?.invalidate()
        }
        let timerInterl: TimeInterval = Double(configuration.scrollAnimationDurationOnMenuItemTap) * 0.001
        tapTimer = Timer.scheduledTimer(timeInterval: timerInterl, target: self, selector: #selector(MoePageMenuController.scrollViewDidEndScrollingAnimation(_:)), userInfo: nil, repeats: false)
    }
}
