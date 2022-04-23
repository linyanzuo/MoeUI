//
//  NSObject.swift
//  MoeCommon
//
//  Created by Zed on 2022/4/23.
//

import Foundation


public extension TypeWrapperProtocol where WrappedType: NSObject {
    var clazzName: String {
        let clazz: AnyClass? = object_getClass(wrappedValue.self)
        return NSStringFromClass(clazz!)
    }

    static var clazzName: String {
        let clazz: AnyClass? = object_getClass(WrappedType.self)
        return NSStringFromClass(clazz!)
    }
    
    var typeName: String {
        return String(describing: type(of: wrappedValue.self))
    }
    
    static var typeName: String {
        return String(describing: WrappedType.self)
    }
}
