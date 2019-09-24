//
//  Unity.swift
//  MoeUI
//
//  Created by Zed on 2019/8/6.
//

import UIKit


/// provide some class method for make appearance or UI control
public class MoeUI: NSObject {}
/// Appearance attribute model, used for save attribute value
protocol AppearanceAttribute {}
/// Attribute configurator, responsible for apply attrubutes in appearance
protocol AppearanceAttributer {}


public protocol AppearanceUnity where Self: UIView {
    var appearance: Appearance { get set }

    func applyAttribute()
}
extension AppearanceUnity {
    public init(appearance: Appearance) {
        self.init(frame: .zero)
        self.appearance = appearance
        self.applyAttribute()
    }

    public init(_ closure: AppearanceClosure) {
        self.init(frame: .zero)
        closure(self.appearance)
        self.applyAttribute()
    }

    public init?(identifier: AppearanceIdentifier) {
        guard let appearance = AppearanceRegister.shared.dequeue(with: identifier) else {
            MLog("Reset Appearance Fail. Can't find appearance which matches to identifier")
            return nil
        }
        self.init(appearance: appearance)
    }

    public func updateAppearance(_ closure: AppearanceClosure) {
        closure(self.appearance)
        self.applyAttribute()
    }

    public func resetAppearance(_ closure: AppearanceClosure) {
        self.appearance = Appearance()
        closure(self.appearance)
        self.applyAttribute()
    }

    public func resetAppearance(appearance: Appearance) {
        self.appearance = appearance
        self.applyAttribute()
    }

    public func resetAppearance(identifier: AppearanceIdentifier) {
        guard let appearance = AppearanceRegister.shared.dequeue(with: identifier) else {
            MLog("Reset Appearance Fail. Can't find appearance which matches to identifier")
            return
        }
        self.resetAppearance(appearance: appearance)
    }
}
