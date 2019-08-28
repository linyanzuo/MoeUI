//
//  Unity.swift
//  MoeUI
//
//  Created by Zed on 2019/8/6.
//

import Foundation


/// 提供快速使用的类方法
public class MoeUI: NSObject {}
/// 配置原型, 保存配置数据
protocol AppearanceAttribute {}
/// 配置器, 负责生成配置
protocol AppearanceAttributer {}


/// Appearance 统一协议
protocol AppearanceUnity where Self: UIView {
    var appearance: Appearance { get set }

    func applyAppearanceMoe()
    func updateAppearance(_ closure: AppearanceClosure)

    //    func availableAppearance() -> Array<UInt>
}
extension AppearanceUnity {
    public init(appearanceMoe: Appearance) {
        self.init(frame: .zero)
        self.appearance = appearance
        self.applyAppearanceMoe()
    }

    public init(_ closureMoe: AppearanceClosure) {
        self.init(frame: .zero)
        closureMoe(self.appearance)
        self.applyAppearanceMoe()
    }

    func applyAppearanceMoe() {
        self.applyBackgroundAppearanceMoe()
    }

    // MARK: Appearance Method
    func applyBackgroundAppearanceMoe() {
        let attr = self.appearance.backgrounder.attribute

        guard attr.color != nil else { return }
        self.backgroundColor = attr.color
        if attr.cornerRadius != nil {
            if attr.isMaskCornerRadius == true {
                let maskColor = self.superview?.backgroundColor
                self.layer.addCornerRadius(attr.cornerRadius!, maskColor: maskColor ?? UIColor.white)
            } else {
                self.layer.cornerRadius = attr.cornerRadius!
            }
        }

        if attr.border?.width ?? 0.0 > 0.0 {
            layer.borderWidth = attr.border!.width!
            layer.borderColor = (attr.border?.color ?? UIColor.black).cgColor
        }

        if let gradient = attr.gradient {
            var cgColors: [CGColor] = []
            for color in gradient.colors {
                cgColors.append(color.cgColor)
            }

            self.gradientLayer.frame = self.layer.bounds
            self.gradientLayer.colors = cgColors
            self.gradientLayer.locations = gradient.locations
            self.gradientLayer.startPoint = gradient.startPoint
            self.gradientLayer.endPoint = gradient.endPoint
            if attr.cornerRadius != nil { gradientLayer.cornerRadius = attr.cornerRadius! }

            self.layer.addSublayer(gradientLayer)
        }
    }

}
