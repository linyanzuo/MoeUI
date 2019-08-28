//
//  PageMenuController+Scroll.swift
//  PageMenu
//
//  Created by Zed on 2019/5/23.
//
//  扩展 - 滚动处理

import UIKit


extension MoePageMenuController: UIScrollViewDelegate {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if didLayoutSubviewsAfterRotation == true {
            didLayoutSubviewsAfterRotation = false
            // 滚动时, 移动选中指示器
            moveSelectionIndicator(currentPageIndex)
        }
        else {
            if scrollView.isEqual(controllerView) {
                controllerViewDidScroll()
            }
        }
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isEqual(controllerView) {
            controllerViewDidEndDecelerating()
        }
    }
    
    /// 拖拽controllerView时的处理
    func controllerViewDidScroll() {
        let contentOffsetX = controllerView.contentOffset.x
        
        if contentOffsetX < 0.0 || contentOffsetX > CGFloat(controllerArray.count - 1) * view.frame.width {
            if menuView.contentSize.width > view.frame.width {
                let ratio: CGFloat = (menuView.contentSize.width - view.frame.width) / (controllerView.contentSize.width - self.view.frame.width)
                let offset = CGPoint(x: contentOffsetX * ratio, y: menuView.contentOffset.y)
                menuView.setContentOffset(offset, animated: false)
            }
        }
        else {
            if currentOrientationIsPortrait && UIApplication.shared.statusBarOrientation.isPortrait
                || !currentOrientationIsPortrait && UIApplication.shared.statusBarOrientation.isLandscape {
                
                // 检查滚动方向是否有变化
                if isTapMenuItemToScroll == false {
                    if didScrollAlready {
                        var newScrollDirection: PageMenuScrollDirection = .other
                        if (CGFloat(startingPageForScroll) * controllerView.frame.width > contentOffsetX) {
                            newScrollDirection = .right
                        } else if (CGFloat(startingPageForScroll) * controllerView.frame.width < contentOffsetX) {
                            newScrollDirection = .left
                        }
                        
                        // 滚动方向发生改变
                        if newScrollDirection != .other && lastScrollDirection != newScrollDirection {
                            let nextIndex: Int = newScrollDirection == .left ? currentPageIndex + 1 : currentPageIndex - 1
                            if nextIndex >= 0 && nextIndex < controllerArray.count {
                                // 检查目标页面是否已经在pageDictionary当中
                                if pagesAddedDictionary[nextIndex] != nextIndex {
                                    addControllerPageAtIndex(nextIndex)
                                    pagesAddedDictionary[nextIndex] = nextIndex
                                }
                            }
                        }
                        
                        lastScrollDirection = newScrollDirection
                    }
                    else {
                        // 向左划动
                        if (lastControllerScrollViewContentOffset > controllerView.contentOffset.x) {
                            if currentPageIndex != controllerArray.count - 1 {
                                // 向当前页的左边添加页面
                                let nextPageIndex: Int = currentPageIndex - 1
                                if pagesAddedDictionary[nextPageIndex] != nextPageIndex && nextPageIndex < controllerArray.count && nextPageIndex >= 0 {
                                    addControllerPageAtIndex(nextPageIndex)
                                    pagesAddedDictionary[nextPageIndex] = nextPageIndex
                                }
                                lastScrollDirection = .right
                            }
                        }
                        // 向右划动
                        else if (lastControllerScrollViewContentOffset < controllerView.contentOffset.x) {
                            if currentPageIndex != 0 {
                                // 向当前页面的右边添加页面
                                let nextPageIndex: Int = currentPageIndex + 1
                                if pagesAddedDictionary[nextPageIndex] != nextPageIndex && nextPageIndex < controllerArray.count && nextPageIndex >= 0 {
                                    addControllerPageAtIndex(nextPageIndex)
                                    pagesAddedDictionary[nextPageIndex] = nextPageIndex
                                }
                                lastScrollDirection = .left
                            }
                        }
                        didScrollAlready = true
                    }
                    
                    lastControllerScrollViewContentOffset = controllerView.contentOffset.x
                }
                
                // 计算controllerView的已滚动占比
                let ratio: CGFloat = (menuView.contentSize.width - view.frame.width) / (controllerView.contentSize.width - view.frame.width)
                // 如果menuView可滚动, 则与controllerView同步已滚动占比
                if menuView.contentSize.width > view.frame.width {
                    let offset = CGPoint(x: controllerView.contentOffset.x * ratio, y: menuView.contentOffset.y)
                    menuView.setContentOffset(offset, animated: false)
                }
                
                // 计算滚动此时对应的当前页
                let width: CGFloat = controllerView.frame.size.width
                let scrollToPageIndex: Int = Int((controllerView.contentOffset.x + (0.5 * width)) / width)
                // 如果当前页变化则对controllerView进行更新
                if scrollToPageIndex != currentPageIndex {
                    lastPageIndex = currentPageIndex
                    currentPageIndex = scrollToPageIndex
                    
                    // 添加目标页面(上一页或下一页)
                    if pagesAddedDictionary[scrollToPageIndex] != scrollToPageIndex && scrollToPageIndex < controllerArray.count && scrollToPageIndex >= 0 {
                        addControllerPageAtIndex(scrollToPageIndex)
                        pagesAddedDictionary[scrollToPageIndex] = scrollToPageIndex
                    }
                    
                    // 手动拖拽controllerView触发的滚动,
                    if !isTapMenuItemToScroll {
                        // 将最后展示页添加到pagesAddedDictionary, 确保滚动完成后最后展示页会被移除
                        if pagesAddedDictionary[lastPageIndex] != lastPageIndex {
                            pagesAddedDictionary[lastPageIndex] = lastPageIndex
                        }
                        
                        // 确保在快速滚动时, 内存中至多有三个页面视图(上页|当前页|下页); 其它情况下内存中仅有一个当前页
                        let indexLeftTwo: Int = scrollToPageIndex - 2
                        if pagesAddedDictionary[indexLeftTwo] == indexLeftTwo {
                            pagesAddedDictionary.removeValue(forKey: indexLeftTwo)
                            removeControllerPageAtIndex(indexLeftTwo)
                        }
                        let indexRightTwo: Int = scrollToPageIndex + 2
                        if pagesAddedDictionary[indexRightTwo] == indexRightTwo {
                            pagesAddedDictionary.removeValue(forKey: indexRightTwo)
                            removeControllerPageAtIndex(indexRightTwo)
                        }
                    }
                }
                // 滚动时, 移动选中指示器
                moveSelectionIndicator(scrollToPageIndex)
            }
        }
    }
    
    func controllerViewDidEndDecelerating() {
        // 通知代理方法
        let currentController = controllerArray[currentPageIndex]
        delegate?.didMoveToPage?(currentController, index: currentPageIndex)
        
        // 滚动减速结束后, 移除掉除了当前页之外的所有页面
        for pageIndex in pagesAddedDictionary.keys {
            if pageIndex != currentPageIndex {
                removeControllerPageAtIndex(pageIndex)
            }
        }
        
        didScrollAlready = false
        startingPageForScroll = currentPageIndex
        
        // 清空所有记录的页面缓存
        pagesAddedDictionary.removeAll(keepingCapacity: false)
    }
    
    @objc public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 通知代理方法
        let currentController = controllerArray[currentPageIndex]
        delegate?.didMoveToPage?(currentController, index: currentPageIndex)
        
        // 滚动减速结束后, 移除掉除了当前页之外的所有页面
        for pageIndex in pagesAddedDictionary.keys {
            if pageIndex != currentPageIndex {
                removeControllerPageAtIndex(pageIndex)
            }
        }
        
        startingPageForScroll = currentPageIndex
        isTapMenuItemToScroll = false
        
        // 清空所有记录的页面缓存
        pagesAddedDictionary.removeAll(keepingCapacity: false)
    }
    
}
