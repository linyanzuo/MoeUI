//
//  AppearanceManager.swift
//  MoeUI
//
//  Created by Zed on 2019/8/5.
//

import UIKit


public struct AppearanceIdentifier: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

//    static let `default` = AppearanceIdentifier(rawValue: 0)
}


class AppearanceManager {
    static let shared = AppearanceManager()
    private init() {}

    // Todo: Persistent Stores
    var appearanceCache: [UInt: Appearance] = [:]

    @discardableResult
    public func register(identifier: AppearanceIdentifier, for appearance: Appearance) -> Bool {
        guard appearanceCache.keys.contains(identifier.rawValue) == false else {
            MLog("标识为`\(identifier.rawValue)`的外观样式已经注册, 请更换其它Key值")
            return false
        }
        appearanceCache[identifier.rawValue] = appearance
        return true
    }

    @discardableResult
    public func register(identifier: AppearanceIdentifier, _ closure: AppearanceClosure) -> Bool {
        let appearance = Appearance()
        closure(appearance)
        return register(identifier: identifier, for: appearance)
    }

    public func unRegister(with identifier: AppearanceIdentifier) {
        guard appearanceCache.keys.contains(identifier.rawValue) == true else {
            MLog("标识为`\(identifier.rawValue)`的外观样式尚未注册, 无法取消注册")
            return
        }
        appearanceCache.removeValue(forKey: identifier.rawValue)
    }

    public func dequeue(with identifier: AppearanceIdentifier) -> Appearance? {
        return appearanceCache[identifier.rawValue]
    }
}


extension MoeUI {
    @discardableResult
    public static func register(identifier: AppearanceIdentifier, _ closure: AppearanceClosure) -> Bool {
        return AppearanceManager.shared.register(identifier: identifier, closure)
    }

    @discardableResult
    public static func register(identifier: AppearanceIdentifier, for appearance: Appearance) -> Bool {
        return AppearanceManager.shared.register(identifier: identifier, for: appearance)
    }
}
