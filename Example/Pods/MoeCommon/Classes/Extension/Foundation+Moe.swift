//
//  Foundation+Moe.swift
//  MoeCommon
//
//  Created by Zed on 2019/11/20.
//

import Foundation


// MARK: - Bundle
public extension Bundle {
    /// Info.plist文件匹配的字典值
    struct InfoPlist {
        /// 命名空间
        public var namespace: String? = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String
        /// 应用版本号
        public var appVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        /// 应用BundleID
        public var bundleID: String? = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }
    
    /// info.plist 字典映射
    static var infoPlist: InfoPlist = InfoPlist()
}


// MARK: - CGSize
public extension CGSize {
    /// 返回（最大宽度，指定高度）的尺寸
    static func maxWidth(height: CGFloat) -> CGSize {
        return CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
    }
    
    /// 返回（指定宽度，最大高度）的尺寸
    static func maxHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    }
}


// MARK: - URL
extension URL: NamespaceWrappable {}
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
