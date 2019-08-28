//
//  GradientVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/8/9.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI


class GradientVC: UIViewController {
    @IBOutlet weak var firstBtn: GradientButton!
    @IBOutlet weak var secondBtn: GradientButton!
    @IBOutlet weak var firstLabel: GradientLabel!

    class func storyboardInstance() -> GradientVC? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NSStringFromClass(self.classForCoder())) as? GradientVC
    }

    override func viewDidLoad() {
        firstBtn.addGradientLayer(backgroundColor: UIColor(rgb: 0xD40C0C),
                                  startColor: UIColor(rgb: 0x048DF7),
                                  endColor: UIColor(rgb: 0x5F4AF0),
                                  startPoint: CGPoint(x: 0.0, y: 0.5),
                                  endPoint: CGPoint(x: 1.0, y: 0.5))

        secondBtn.backgroundColor = .black
        secondBtn.addGradient(startPoint: CGPoint(x: 0.9, y: 0.5),
                              endPoint: CGPoint(x: 1.0, y: 1.0),
                              colors: [UIColor(rgb: 0x048DF7), UIColor(rgb: 0x5F4AF0)],
                              locations: [0, 1])

        firstLabel.addGradient(startPoint: CGPoint(x: 0.9, y: 0.5),
                               endPoint: CGPoint(x: 1.0, y: 1.0),
                               colors: [UIColor(rgb: 0x048DF7), UIColor(rgb: 0x5F4AF0)],
                               locations: [0, 1])
    }

}


class GradientLabel: UILabel {
    func addGradient(startPoint: CGPoint, endPoint: CGPoint, colors: [UIColor], locations: [NSNumber]) {
        var cgColors: [CGColor] = []
        for color in colors {
            cgColors.append(color.cgColor)
        }

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 16, height: self.bounds.height)
        gradientLayer.colors = cgColors
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        self.layer.addSublayer(gradientLayer)
        self.layer.cornerRadius = 16;
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.gradientLayer.frame = self.bounds
    }
}


class GradientButton: UIButton {
    func addGradientLayer(backgroundColor: UIColor, startColor: UIColor, endColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) {
        let layerView = UIView()
        layerView.frame = self.bounds
        self.addSubview(layerView)

        // layerFillCode
        let layer = CALayer()
        layer.frame = layerView.bounds
        layer.backgroundColor = backgroundColor.cgColor
        layer.cornerRadius = 16
        layerView.layer.addSublayer(layer)

        // gradientCode
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.9, 1]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = layerView.bounds
        gradientLayer.cornerRadius = 16
        layerView.layer.addSublayer(gradientLayer)
        layerView.layer.cornerRadius = 16;
    }

    func addGradient(startPoint: CGPoint, endPoint: CGPoint, colors: [UIColor], locations: [NSNumber]) {
        var cgColors: [CGColor] = []
        for color in colors {
            cgColors.append(color.cgColor)
        }

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = cgColors
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.cornerRadius = 16
        self.layer.addSublayer(gradientLayer)
        self.layer.cornerRadius = 16;
    }
}
