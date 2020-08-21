//
//  Created by Zed on 2020/8/18.
//  Copyright © 2020 www.moemone.com. All rights reserved.
//

import UIKit


public extension UIColor {
    
    /// 随机颜色
    class var random: UIColor {
        get {
            let red = CGFloat(arc4random() % 256) / 255.0
            let green = CGFloat(arc4random() % 256) / 255.0
            let blue = CGFloat(arc4random() % 256) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    /// 返回RGB值对应的`UIColor`实例
    /// - Parameter rgb: RGB值的16进制表示，如`0xFFFFFF`
    convenience init(rgb: UInt32) {
        let rgba = rgb << 8 | 0x000000FF
        self.init(rgba: rgba)
    }

    /// 返回RGBA值对应的`UIColor`实例
    /// - Parameter rgba: RGBA值的16进制表示，如`0x000000FF`
    convenience init(rgba: UInt32) {
        let red = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let blue = CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
        let alpha = CGFloat(rgba & 0x000000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}

