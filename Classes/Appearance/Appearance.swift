//
//  Appearance.swift
//  MoeUI
//
//  Created by Zed on 2019/7/30.
//

import UIKit


public typealias AppearanceClosure = (_ attr: Appearance) -> Void


public class Appearance: NSObject {
    private(set) var texters: [TextAttributer] = []
    private(set) var imagers: [ImageAttributer] = []
    private(set) var backgrounder: BackgroundAttributer = BackgroundAttributer()
    private(set) var shadower: ShadowAttributer = ShadowAttributer()

    @discardableResult
    public func text(_ text: String, state: UIControl.State = .normal) -> TextAttributer {
        var texter: TextAttributer? = nil
        for existedTexter in texters {
            if existedTexter.attribute.state == state {
                texter = existedTexter
                break
            }
        }
        if texter == nil { texter = TextAttributer() }

        texter!.text(text, state: state)
        texters.append(texter!)
        return texter!
    }

    @discardableResult
    public func background(color: UIColor) -> BackgroundAttributer {
        backgrounder.background(color: color)
        return backgrounder
    }

    @discardableResult
    public func backgroundImage(_ image: UIImage, state: UIControl.State = .normal) -> ImageAttributer {
        let imager = getImager(for: state)
        imager.backgroundImage(image, state: state)
        imagers.append(imager)
        return imager
    }

    @discardableResult
    public func image(_ image: UIImage, state: UIControl.State = .normal) -> ImageAttributer {
        let imager = getImager(for: state)
        imager.image(image, state: state)
        imagers.append(imager)
        return imager
    }

    @discardableResult
    public func shadow(color: UIColor) -> ShadowAttributer {
        shadower.color(color)
        return shadower
    }

    // MARK: Private Method
    private func getImager(for state: UIControl.State) -> ImageAttributer {
        var imager: ImageAttributer? = nil
        for existedImager in imagers {
            if existedImager.attribute.state == state {
                imager = existedImager
                break
            }
        }
        if imager == nil { imager = ImageAttributer() }

        return imager!
    }
}


// MARK: UIView + Appearance
extension RuntimeKey {
    static let appearance = MRuntimeKey(for: "Appearance")!
    static let gradientLayer = MRuntimeKey(for: "GradientLayer")!
}
extension UIView: Runtime {
    @objc public var appearance: Appearance {
        get {
            var _appearance = objc_getAssociatedObject(self, RuntimeKey.appearance) as? Appearance
            if _appearance == nil {
                _appearance = Appearance()
                objc_setAssociatedObject(self, RuntimeKey.appearance, _appearance, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return _appearance!
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.appearance, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc public var gradientLayer: CAGradientLayer {
        get {
            var _gradientLayer = getAssociatedObject(for: RuntimeKey.gradientLayer) as? CAGradientLayer
            if _gradientLayer == nil {
                _gradientLayer = CAGradientLayer()
                setAssociatedRetainObject(object: _gradientLayer, for: RuntimeKey.gradientLayer)
            }
            return _gradientLayer!
        }
        set { setAssociatedRetainObject(object: newValue, for: RuntimeKey.gradientLayer) }
    }
}


// MARK: MoeUI + Appearance
extension MoeUI {
    public static func makeAppearance(_ closure: AppearanceClosure) -> Appearance {
        let appearance = Appearance()
        closure(appearance)
        return appearance
    }
}
