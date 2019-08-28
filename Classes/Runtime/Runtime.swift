//
//  Runtime.swift
//  MoeUI
//
//  Created by Zed on 2019/7/25.
//

import UIKit


public func MRuntimeKey(for name: String, file: String = #file) -> Runtime.Key? {
    let fileName = NSString(string: file).pathComponents.last!
    let strValue = String(format: "[%@]: %@", fileName, name)
    return UnsafeRawPointer(bitPattern: strValue.hashValue)
}
public struct RuntimeKey {}


let valueTypesMap: Dictionary<String, Any> = [
    "c" : Int8.self,
    "s" : Int16.self,
    "i" : Int32.self,
    "q" : Int.self,         // Also `Int64`, `NSInteger` in 64bit Platform
    "S" : UInt16.self,
    "I" : UInt32.self,
    "Q" : UInt.self,        // Also `UInt64` in 64bit Platform
    "B" : Bool.self,
    "d" : Double.self,
    "f" : Float.self,
    "{" : Decimal.self
]


public protocol Runtime {
    typealias Key = UnsafeRawPointer
}
public extension Runtime {
    // MARK: Associated Object
    func getAssociatedObject(for key: Runtime.Key) -> Any? {
        return objc_getAssociatedObject(self, key)
    }

    func setAssociatedRetainObject(object: Any?, for key: Runtime.Key) {
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func setAssociatedAssignValue(object: Any?, for key: Runtime.Key) {
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_ASSIGN)
    }

    func setAssociatedCopyObject(object: Any?, for key: Runtime.Key) {
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }

    // MARK: Property And Type

    /// return all type of propertys in class
    func getTypesOfProperties(in clazz: AnyClass?) -> Dictionary<String, Any>? {
        var count = UInt32()
        guard let properties = class_copyPropertyList(clazz, &count)
            else { return nil }
        var types: Dictionary<String, Any> = [:]
        for i in 0..<Int(count) {
            let property: objc_property_t = properties[i]

            guard let name = getNameOf(property: property)
                else { continue }
            let type = getTypeOf(property: property)
            types[name] = type
        }
        free(properties)
        return types
    }

    /// check if the class has property of specify name
    func isProperty(name: String, availableIn clazz: AnyClass?) -> Bool {

        guard let properties = getTypesOfProperties(in: clazz)
            else { return false }

        for key in properties.keys {
            if key == name { return true }
        }
        return false
    }

    /// return the name of property
    func getNameOf(property: objc_property_t) -> String? {
        guard let name: NSString = NSString(utf8String: property_getName(property))
            else { return nil }

        return name as String
    }

    /// retrun the type of property
    func getTypeOf(property: objc_property_t) -> Any {
        guard
            let attributes = property_getAttributes(property),
            let attrAsString: NSString = NSString(utf8String: attributes)
            else { return Any.self }

        // Tq,N,Vcount                  : `Int` type, named `count`
        // T@"NSString",N,R,Vtitle      : `NSString` type, named `title`
        let attrString = attrAsString as String
        // [Tq,N,Vcount]
        // ["T@", "NSString", ",N,R,Vtitle"]
        let slices = attrString.components(separatedBy: "\"")

        guard slices.count > 1
            else { return valueType(withAttributes: attrString) }
        let objectClassName = slices[1]
        let objectClass = NSClassFromString(objectClassName) as! NSObject.Type

        return objectClass
    }

    /// return type which association with attribute, see `valueTypesMap`
    func valueType(withAttributes attributes: String) -> Any {
        // "Tq,N,Vcount" : `Int` type, named `count`
        let letter = attributes.moe.subString(start: 1, length: 1)
        guard let type = valueTypesMap[letter]
            else { return Any.self }

        return type
    }

    // MARK: Method Swizzle

    /// exchange target's original method and replace method
    func swizzleInstanceMethod(target: AnyClass, original: Selector, replace: Selector) {
        let originalMethod = class_getInstanceMethod(target.class(), original)
        let targetMethod = class_getInstanceMethod(target.class(), replace)
        guard originalMethod != nil, targetMethod != nil else { return }
        method_exchangeImplementations(originalMethod!, targetMethod!)
    }
}
