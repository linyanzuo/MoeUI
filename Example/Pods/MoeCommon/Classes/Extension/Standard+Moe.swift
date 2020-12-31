//
//  Standard.swift
//  MoeCommon
//
//  Created by Zed on 2019/11/19.
//


// MARK: - URL

extension TypeWrapperProtocol where WrappedType == URL {
    /// 返回`URL`的`query string`参数字典
    public func queryParameters() -> [String: String?]? {
        guard let components = URLComponents(url: wrappedValue, resolvingAgainstBaseURL: false)
            else { return nil}
        
        var params: [String: String?] = [:]
        if let queryItems = components.queryItems {
            for item in queryItems {
                params[item.name] = item.value
            }
        }
        return params
    }
}

// MARK: - Array

public extension Array where Element: Any {
    /// 将数组拆分成多个子数组，每个子数组的元素个数不超过指定值
    /// - Parameter subSize: 每个子数组最多包含的元素个数
    /// - Returns: 返回拆分后的子数组
    func split(in subSize: Int) -> Array<Array<Element>>? {
        let numberOfSubArray = self.count % subSize == 0 ? (self.count / subSize) : (self.count / subSize + 1)
        guard numberOfSubArray != 0 else { return nil }
        
        var subArrays: [[Element]] = []
        var beginIndex: Int = 0
        for _ in 0..<numberOfSubArray {
            let endIndex: Int = beginIndex + subSize
            let subArray = Array(self[beginIndex..<endIndex])
            subArrays.append(subArray)
            beginIndex += subSize
        }
        return subArrays
    }
    
    /// 获取指定下标的元素
    /// - Parameter index:  指定下标
    /// - Returns:          指定下标对应的元素，若不存在则返回nil
    func objectAt(_ index: Int) -> Element? {
        guard self.count > index else { return nil }
        return self[index]
    }
}


// MARK: - Operator

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
