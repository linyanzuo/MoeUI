//
//  Created by Zed on 2020/8/18.
//  Copyright © 2020 www.moemone.com. All rights reserved.
//
/**
 【表格视图】相关扩展
 */

import UIKit


public extension TypeWrapperProtocol where WrappedType: UITableView {
    /// 设置自定义TableHeaderView，注意该视图只需要约束宽高值，宽度通常与TableView一致
    /// - Parameter view: 设置为TableHeaderView的自定义视图
    func setTableHeaderView(view: UIView) {
        wrappedValue.tableHeaderView = view
        wrappedValue.autoresizingMask = UIView.AutoresizingMask(rawValue: 0)
    }
    
    /// 向表格视图(TableView)批量注册单元格(Cell)和页眉页脚(HeaderFooter)，注册的复用ID值为类名
    /// - Parameters:
    ///   - cellClasses:            包含单元格类型的数组
    ///   - headerFooterClasses:    包含页眉页脚类型的数组，为nil时则不注册
    func registerCells<T: UITableViewCell, AT: UITableViewHeaderFooterView>(
        cellClasses: Array<T.Type>,
        headerFooterClasses: Array<AT.Type>? = nil
    ) {
        for cellClass in cellClasses {
            let reuseId = cellClass.moe.clazzName
            wrappedValue.register(cellClass, forCellReuseIdentifier: reuseId)
        }
        if (headerFooterClasses == nil) { return }
        for headerFooterClass in headerFooterClasses! {
            let reuseId = headerFooterClass.moe.clazzName
            wrappedValue.register(headerFooterClass, forHeaderFooterViewReuseIdentifier: reuseId)
        }
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
