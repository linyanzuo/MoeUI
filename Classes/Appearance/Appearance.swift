//
//  Appearance.swift
//  MoeUI
//
//  Created by Zed on 2019/7/30.
//

import UIKit


@objc protocol Appearance where Self: UIView {
    var attributer: Attributer { get set }

    func applyAppearance()
    func updateAppearance(_ closure: AppearanceClosure)

//    func availableAppearance() -> Array<UInt>
}


struct RuntimeKey {
    static let attributer = MRuntimeKey(for: "Attributer")!
}
extension UIView {
    @objc public var attributer: Attributer {
        get {
            var _attributer = objc_getAssociatedObject(self, RuntimeKey.attributer) as? Attributer
            if _attributer == nil {
                _attributer = Attributer()
                objc_setAssociatedObject(self, RuntimeKey.attributer, _attributer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return _attributer!
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.attributer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
