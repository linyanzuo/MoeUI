//
//  SwiftyNamespace.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/8/2.
//
//  Base type, struct an so on, use `==`
//  Object type , use `:`

public protocol NamespaceWrappable {
    associatedtype WrapperType
    var moe: WrapperType { get }
    static var moe: WrapperType.Type { get }
}
public extension NamespaceWrappable {
    var moe: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    static var moe: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}


public protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}
public struct NamespaceWrapper<T>: TypeWrapperProtocol {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}
