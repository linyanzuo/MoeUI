//
//  Created by Zed on 2020/8/19.
//  Copyright © 2020 www.moemone.com. All rights reserved.
//

import UIKit


public extension TypeWrapperProtocol where WrappedType: UIView {

    static func loadNib() -> WrappedType? {
        let nibName = String(describing: WrappedType.self)
        let instance = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first
        return instance as? WrappedType
    }

}
