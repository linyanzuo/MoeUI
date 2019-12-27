//
//  AppearanceManager.swift
//  MoeUI
//
//  Created by Zed on 2019/8/5.
//

import UIKit
import MoeCommon


public typealias AppearanceIdentifier = String


public class AppearanceRegister {
    private var appearanceCache: [AppearanceIdentifier: Appearance] = [:]

    public static let shared = AppearanceRegister()
    private init() {}

    // MARK: Public Method
    public static func generateIdentifier() -> AppearanceIdentifier {
        return UUID().uuidString
    }

    @discardableResult
    public func register(identifier: AppearanceIdentifier, for appearance: Appearance) -> Bool {
        guard isRegistered(identifier: identifier) == false else {
            MLog("FAIL: Appearance which identify by`\(identifier)` has already registered, please try again by using another identifier")
            return false
        }
        appearanceCache[identifier] = appearance
        return true
    }

    @discardableResult
    public func register(identifier: AppearanceIdentifier, _ closure: AppearanceClosure) -> Bool {
        let appearance = Appearance()
        closure(appearance)
        return register(identifier: identifier, for: appearance)
    }

    public func dequeue(with identifier: AppearanceIdentifier) -> Appearance? {
        if isRegistered(identifier: identifier) {
            return appearanceCache[identifier]
        }
        return nil
    }

    public func isRegistered(identifier: AppearanceIdentifier) -> Bool {
        return appearanceCache.keys.contains(identifier)
    }

    public func unRegister(with identifier: AppearanceIdentifier) {
        guard appearanceCache.keys.contains(identifier) == true else {
            MLog("FAIL: Appearance which identify by `\(identifier)` is not registered")
            return
        }
        appearanceCache.removeValue(forKey: identifier)
    }
}


extension MoeUI {
    public static func generateID() -> AppearanceIdentifier {
        return AppearanceRegister.generateIdentifier()
    }
    
    @discardableResult
    public static func register(identifier: AppearanceIdentifier, _ closure: AppearanceClosure) -> Bool {
        return AppearanceRegister.shared.register(identifier: identifier, closure)
    }

    @discardableResult
    public static func register(identifier: AppearanceIdentifier, for appearance: Appearance) -> Bool {
        return AppearanceRegister.shared.register(identifier: identifier, for: appearance)
    }
}
