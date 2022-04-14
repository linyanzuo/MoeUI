//
//  Standard.swift
//  MoeCommon
//
//  Created by Zed on 2019/11/19.
//

/// 将右侧数组的元素追加至左侧数组内
/// - Parameter left: 左侧数组，右侧数组值将追加至此
/// - Parameter right: 右侧数组，其元素将被追加到左侧数组内
public func += <Type> (left: inout Array<Type>, right: Array<Type>) {
    for value in right { left.append(value) }
}

/// 将右侧字典的元素追加至左侧字典内
/// - Parameter left: 左侧字典，右侧字典值将追加至此
/// - Parameter right: 右侧字典，其元素将被追加到左侧字典内
public func += <KeyType, ValueType> (
    left: inout Dictionary<KeyType, ValueType>,
    right: Dictionary<KeyType, ValueType>)
{
    for (key, value) in right { left.updateValue(value, forKey: key) }
}
