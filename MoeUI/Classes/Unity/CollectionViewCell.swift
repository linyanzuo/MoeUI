//
//  Created by Zed on 2019/7/19.
//  Copyright © 2019 www.moemone.com. All rights reserved.
//

import UIKit


/// 集合视图的单元项基类
open class CollectionViewCell: UICollectionViewCell, ViewUnity {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubview()
        self.setupConstraint()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubview()
        self.setupConstraint()
    }
    
    /// 【统一规范】子视图初始化方法
    /// ---
    /// 子类重写该方法, 实现视图中"子视图的初始化"工作
    /// * 如果通过IB加载视图, 则直接在`awakeFromNib`方法中完成初始化
    /// * 本方法只负责子视图的实例化配置, 约束操作在`setupConstraint`方法中完成
    /// * 使用"懒加载"创建的子视图，不需要在该方法中做初始化.
    open func setupSubview() {}
    
    //// 【统一规范】子视图约束初始化方法
    /// 子类重写该方法, 实现视图中"子视图约束的初始化"工作, 方便纯代码结构时能清晰获取视图结构
    /// * 如果通过IB加载视图, 则直接在`awakeFromNib`方法中完成初始化
    /// * 使用"懒加载"创建的子视图，不需要在该方法中做初始化.
    open func setupConstraint() {}
}
