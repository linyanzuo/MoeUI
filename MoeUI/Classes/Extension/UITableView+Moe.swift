//
//  UITableView+Moe.swift
//  MoeUI
//
//  Created by Zed on 2022/4/23.
//
// 【表格视图】相关扩展

import UIKit
import MoeCommon


public extension TypeWrapperProtocol where WrappedType: UITableView {
    /// 设置自定义TableHeaderView，注意该视图只需要约束宽高值，宽度通常与TableView一致。
    /// `注意Xib加载视图作为TableHeaderView时高度异常，外嵌UIView可解决`
    /// - Parameter view: 设置为TableHeaderView的自定义视图
    func setTableHeaderView(view: UIView) {
        wrappedValue.tableHeaderView = view
        wrappedValue.autoresizingMask = UIView.AutoresizingMask(rawValue: 0)
    }
    
    /// 向表格视图(TableView)注册单元格(Cell), 注册的复用ID值为类名
    ///   - cellClasses:            单元格类型
    func registerCell<T: UITableViewCell>(cellClass: T.Type) {
        let reuseId = cellClass.moe.clazzName
        wrappedValue.register(cellClass, forCellReuseIdentifier: reuseId)
    }
    
    /// 向表格视图(TableView)注册页眉页脚(HeaderFooter)，注册的复用ID值为类名
    ///   - headerFooterClasses:    页眉页脚类型
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(headerFooterClass: T.Type) {
        let reuseId = headerFooterClass.moe.clazzName
        wrappedValue.register(headerFooterClass, forHeaderFooterViewReuseIdentifier: reuseId)
    }
    
    /// 从表格视图(TableView)中取出可复用的单元格(Cell)，若获取失败会抛出错误并中止运行
     /// 调用此方法前必须先调用「registerCells(cellClasses: headerFooterClasses:)」方法注册单元格
     /// - Parameter cellClass:  单元格类型
     /// - Returns:              可复用的单元格实例
     func dequeueCell<T: UITableViewCell>(cellClass: T.Type) -> T {
         let reuseId = T.moe.clazzName
         if let cell = wrappedValue.dequeueReusableCell(withIdentifier: reuseId) {
             return cell as! T
         } else {
             fatalError("`dequeueCell`找不到与标识「\(reuseId)」对应的可复用CELL实例，请检查代码")
         }
     }
    
    /// 从表格视图(TableView)中取出可复用的页眉或页脚(HeaderFooter)，若获取失败会抛出错误并中止运行
    /// 调用此方法前必须先调用「registerCells(cellClasses: headerFooterClasses:)」方法注册页眉或页脚
    /// - Parameter headerFooterClass:  页眉（页脚）类型
    /// - Returns:                      可复用的页眉（页脚）实例
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(headerFooterClass: T.Type) -> T {
        let reuseId = T.moe.clazzName
        if let headerFooter = wrappedValue.dequeueReusableHeaderFooterView(withIdentifier: reuseId) {
            return headerFooter as! T
        } else {
            fatalError("`dequeueHeaderFooter`找不到与标识「\(reuseId)」对应的可复用Header或Footer实例，请检查代码")
        }
    }
}

