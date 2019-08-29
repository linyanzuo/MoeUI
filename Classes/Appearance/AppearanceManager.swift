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
            MLog("FAIL: Appearance which identify by`\(identifier.rawValue)` has already registered, please try again by using another identifier")
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
            MLog("FAIL: Appearance which identify by `\(identifier.rawValue)` is not registered")
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
