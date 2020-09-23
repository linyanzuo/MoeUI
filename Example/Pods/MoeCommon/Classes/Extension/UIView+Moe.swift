//
//  Created by Zed on 2020/8/19.
//  Copyright © 2020 www.moemone.com. All rights reserved.
//

import UIKit


public extension TypeWrapperProtocol where WrappedType: UIView {
    /// 加载指定名称Xib文件，并实例化第一个控件。
    ///
    /// 调用该方法前，请确认Xib文件已正确配置。即在「Identity inspector > Custom Class」内配置：
    /// 1. Class为调用类类型，
    /// 2. Module为相应的项目模块
    /// - Parameter xibFileName: Xib文件名称，为nil则使用调用类的类名作为Xib文件名
    /// - Returns: 通过Xib加载得到的实例对象
    static func xibInstance(xibFileName: String? = nil) -> WrappedType? {
        let nibName = xibFileName ?? String(describing: WrappedType.self)
        guard let instances = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil) else {
            fatalError("加载Xib文件失败，请查看「xibInstance」方法说明")
        }
        return instances.first as? WrappedType
    }
}
