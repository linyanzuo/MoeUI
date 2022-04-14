//
//  UIlabel+Blur.swift
//  MoeUI_Example
//
//  Created by Zed on 2021/1/19.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


extension UILabel {
    /// 对文字进行高斯模糊处理
    /// 注意：请确保在调用此方法时，UILabel已经具备正确的Frame值
    /// - Parameter radius: 高斯模糊半径值
    func gaussianBlur(radius: CGFloat) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            guard let textCGImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage,
                  let filter = CIFilter(name: "CIGaussianBlur")
            else { return }
            
            let inputImage = CIImage(cgImage: textCGImage)
            filter.setDefaults()
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            filter.setValue(radius, forKey: kCIInputRadiusKey)
            if let outputImage = filter.outputImage {
                let ciContext = CIContext(options: nil)
                // 在Swift语言中，CGImage由ARC管理，不再需要手动执行CGImageRelease
                let cgImage = ciContext.createCGImage(outputImage, from: inputImage.extent)
                self.layer.contents = cgImage
                print("高斯模糊滤镜尺寸 \(cgImage)：\(text ?? "Empty") \(bounds.size)")
            }
        }
        UIGraphicsEndImageContext()
    }
}
