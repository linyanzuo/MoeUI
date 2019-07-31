//
//  UIView+Appearance.swift
//  MoeUI
//
//  Created by Zed on 2019/7/30.
//

import UIKit


extension UIView: Appearance {
    func applyAppearance() {
        applyBackgroundAppearance()
    }

    public func updateAppearance(_ closure: AppearanceClosure) {
        closure(self.attributer)
        applyAppearance()
    }

    // MARK: Private Method
    private func applyBackgroundAppearance() {
        let attr = self.attributer.backgroundAttribute
        if attr.color != nil { self.backgroundColor = attr.color }
        if attr.cornerRadius != nil {
            if attr.isMaskCornerRadius == false {
                self.layer.cornerRadius = attr.cornerRadius!
            } else {
                let maskColor = self.superview?.backgroundColor
                self.layer.addCornerRadius(attr.cornerRadius!, maskColor: maskColor ?? UIColor.white)
            }
        }
    }
}
