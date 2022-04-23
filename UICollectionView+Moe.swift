//
//  UICollectionView+Moe.swift
//  MoeUI
//
//  Created by Zed on 2022/4/23.
//
// 【集合视图】扩展

import UIKit


public extension TypeWrapperProtocol where WrappedType: UICollectionView {
    /// 向集合视图(CollectionView)注册单元格(Cell)，注册的复用ID值为类名
    /// - Parameters:
    ///   - cellClasses:            单元格类型
    func registerCell<T: UICollectionViewCell>(cellClass: T.Type) {
        let reuseId = cellClass.moe.clazzName
        wrappedValue.register(cellClass, forCellWithReuseIdentifier: reuseId)
    }
    
    /// 从集合视图(CollectionView)中取出可复用的单元格(Cell)，若获取失败会抛出错误并中止运行
    /// 调用此方法前必须先调用「registerCells(cellClasses:)」方法注册单元格
    /// - Parameter cellClass:  单元格类型
    /// - Returns:              可复用的单元格实例
    func dequeueCell<T: UICollectionViewCell>(cellClass: T.Type, for indexPath: IndexPath) -> T {
        let reuseId = T.moe.clazzName
        if let cell = wrappedValue.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? T {
            return cell
        } else {
            fatalError("「dequeueCell」要不到与标识「\(reuseId)」对应的可复用CELL实例，请检查代码")
        }
    }
}


