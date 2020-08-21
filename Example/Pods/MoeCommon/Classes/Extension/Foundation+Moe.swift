//
//  Foundation+Moe.swift
//  MoeCommon
//
//  Created by Zed on 2019/11/20.
//

import Foundation


// MARK: - NSObject

public extension TypeWrapperProtocol where WrappedType: NSObject {

    var clazzName: String {
        return String(describing: wrappedValue.self)
//        let thisType = type(of: self)
//        return String(describing: thisType)
    }

    static var clazzName: String {
        return String(describing: WrappedType.self)
    }

}


// MARK: - UserDefaults

/// 保存多个键值对数据至`用户默认配置`数据库
/// - Parameter pairs: 保存所有要添加键值对的字典
public func userDefaultsSave(pairs: [String: Any?]) {
    let standard = UserDefaults.standard
    for (key, value) in pairs { standard.setValue(value, forKey: key) }
    standard.synchronize()
}

/// 向`用户默认配置`数据库获取指定键对应的值
/// - Parameter key: 指定的键值
public func userDefaultsValue(forKey key: String) -> Any? {
    return UserDefaults.standard.value(forKey: key)
}

/// 删除`用户默认配置`数据库中多个指定的键值对
/// - Parameter keys: 保存所有要删除键的数组
public func userDefaultsRemove(keys: [String]) {
    let standard = UserDefaults.standard
    for key in keys { standard.removeObject(forKey: key) }
    standard.synchronize()
}
