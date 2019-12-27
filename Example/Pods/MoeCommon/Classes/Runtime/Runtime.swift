//
//  Runtime.swift
//  MoeCommon
//
//  Created by Zed on 2019/11/19.
//

import UIKit
import ObjectiveC.runtime


/// 运行时协议，提供了动态获取或调整类的方法。如添加属性、方法交互等
public protocol Runtime {
    typealias Key = UnsafeRawPointer
    
    /// 获取指定键值对应的关联值
    /// - Parameter key: 关联的键值
    func getAssociatedObject(for key: Runtime.Key) -> Any?
    
    /// 使用指定键值绑定对象类型的关联值
    /// - Parameter object: 对象类型的关联值
    /// - Parameter key: 关联的键值
    func setAssociatedRetainObject(object: Any?, for key: Runtime.Key)
    
    /// 使用指定键值绑定基本类型的关联值
    /// - Parameter object: 基本类型的关联值
    /// - Parameter key: 关联的键值
    func setAssociatedAssignValue(object: Any?, for key: Runtime.Key)
    
    /// 使用指定键值绑定指定值的拷贝作为关联
    /// - Parameter object: 指定值
    /// - Parameter key: 关联的键值
    func setAssociatedCopyObject(object: Any?, for key: Runtime.Key)
    
    /// 获取指定类的所有属性的具体类型
    /// - Parameter clazz: 指定的目标类
    func getTypesOfProperties(in clazz: AnyClass?) -> Dictionary<String, Any>?
    
    /// 获取指定属性的名称
    /// - Parameter property: 目标属性
    func getNameOf(property: objc_property_t) -> String?
    
    /// 获取指定属性的类型
    /// - Parameter property: 目标属性
    func getTypeOf(property: objc_property_t) -> Any
}

public extension Runtime {
    
    // MARK: 关联值相关操作
    
    func getAssociatedObject(for key: Key) -> Any? {
        return objc_getAssociatedObject(self, key)
    }

    func setAssociatedRetainObject(object: Any?, for key: Key) {
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func setAssociatedAssignValue(object: Any?, for key: Key) {
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_ASSIGN)
    }

    func setAssociatedCopyObject(object: Any?, for key: Key) {
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    // MARK: 属性相关操作
    
    func getTypesOfProperties(in clazz: AnyClass?) -> Dictionary<String, Any>? {
        var count = UInt32()
        guard let properties = class_copyPropertyList(clazz, &count) else
        { return nil }
        
        var types: Dictionary<String, Any> = [:]
        for i in 0..<Int(count) {
            let property: objc_property_t = properties[i]
            
            guard let name = getNameOf(property: property) else
            { continue }
            
            let type = getTypeOf(property: property)
            types[name] = type
        }
        
        free(properties)
        return types
    }
    
    func checkProperty(name: String, availableIn clazz: AnyClass?) -> Bool {
        guard let properties = getTypesOfProperties(in: clazz) else
        { return false }
        
        for key in properties.keys
        { if key == name { return true } }
        
        return false
    }
    
    func getNameOf(property: objc_property_t) -> String? {
        guard let name = NSString(utf8String: property_getName(property)) else
        { return nil }
        
        return name as String
    }
    
    func getTypeOf(property: objc_property_t) -> Any {
        guard
            let attributes = property_getAttributes(property),
            let attrAsString: NSString = NSString(utf8String: attributes)
            else { return Any.self }
        
        // Tq,N,Vcount              : Int类型的, 属性名为count
        // T@"NSString",N,R,Vtitle  : NSString类型, 属性名为title
        let attrString = attrAsString as String
        // [Tq,N,Vcount]
        // ["T@", "NSString", ",N,R,Vtitle"]
        let slices = attrString.components(separatedBy: "\"")
        
        guard slices.count > 1 else
        { return valueType(withAttributes: attrString) }
        
        let objectClassName = slices[1]
        let objectClass = NSClassFromString(objectClassName) as! NSObject.Type
        
        return objectClass
    }
    
    /// 根据属性的特性(`Attribute`)判断属性的具体类型
    /// - Parameter attributes: 属性的特性
    private func valueType(withAttributes attributes: String) -> Any {
        // Tq,N,Vcount : Int类型的, 属性名为count
        let letter = attributes.moe.subString(start: 1, length: 1)
        guard let type = valueTypesMap[letter] else { return Any.self }
        
        return type
    }
}


/// 根据指定名称及文件名生成运行时的关联键名(`UnsafeRawPointer`)
/// - Parameter name: 键名
/// - Parameter file: 文件名，默认为书写代码的文件
public func runtimeKey(for name: String, file: String = #file) -> Runtime.Key? {
    let fileName = NSString(string: file).pathComponents.last!
    let strValue = String(format: "[%@]: %@", fileName, name)
    return UnsafeRawPointer(bitPattern: strValue.hashValue)
}


/// 对指定类进行方法交换
/// - Parameter target: 要交换方法的类
/// - Parameter original: 原始的旧方法
/// - Parameter replace: 替换的新方法
public func swizzleInstanceMethod(target: AnyClass, original: Selector, replace: Selector) {
    let originalMethod = class_getInstanceMethod(target.class(), original)
    let targetMethod = class_getInstanceMethod(target.class(), replace)
    guard originalMethod != nil, targetMethod != nil else { return }
    method_exchangeImplementations(originalMethod!, targetMethod!)
}


/// 特性值与具体类型的关联
private let valueTypesMap: Dictionary<String, Any> = [
    "c" : Int8.self,
    "s" : Int16.self,
    "i" : Int32.self,
    "q" : Int.self,     // 64位平台时也表示`Int64`、`NSInteger`
    "S" : UInt16.self,
    "I" : UInt32.self,
    "Q" : UInt.self,    // 64位平台时也表示`UInt64`
    "B" : Bool.self,
    "d" : Double.self,
    "f" : Float.self,
    "{" : Decimal.self
]
