//
//  SwiftyNameSpace.swift
//  MoeCommon
//
//  Created by Zed on 2019/11/19.
//

import UIKit


// MARK: - 数据类型包装
/// 类型包装协议
public protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}


// MARK: - 对象类型包装
/// 命名空间包装协议
public protocol NamespaceWrappable {
    associatedtype WrapperType
    var moe: WrapperType { get }
    static var moe: WrapperType.Type { get }
}

public struct NamespaceWrapper<T>: TypeWrapperProtocol {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}

public extension NamespaceWrappable {
    var moe: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    static var moe: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}


// MARK: - NSObject
/// 基础类型需要手动继承NamespaceWrappable
/// 对象类型都继承自NSObject，因此自动继承NamespaceWrappable协议
extension NSObject: NamespaceWrappable {}
