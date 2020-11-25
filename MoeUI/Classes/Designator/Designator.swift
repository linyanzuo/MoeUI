//
//  Designator.swift
//  MoeUIDemo
//
//  Created by Zed on 2019/11/22.
//  Copyright © 2019 www.moemone.com. All rights reserved.
//

import UIKit


/// 样式设计器，负责管理赋值器
public class Designator: NSObject, NSCopying {
    public required override init() {}
    
    /// 创建设计器实例，并携带了指定的多个赋值器
    /// - Parameter valuators: 赋值器数组
    public convenience init(valuators: [Valuator]) {
        self.init()
        self.valuators += valuators
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copyObj = type(of: self).init()
        copyObj.valuators = self.valuators
        return copyObj
    }
    
    /// 携带的所有赋值器
    private var valuators = Array<Valuator>()
    
    /// 将设计器应用到指定控件上
    /// - Parameter control: 目标控件
    public func applyValuator(toView view: ValuationViewProtocol) {
        view.designator = self
        for valuator in view.designator.valuators { valuator.apply(to: view) }
    }
    
    /// 将设计器应用到指定的多个控件上
    /// - Parameter views: 保存了多个控件的数组
    public func applyValuator(toViews views: [ValuationViewProtocol]) {
        for view in views { applyValuator(toView: view) }
    }
    
    // MARK: -- 赋值器配置
    
    /// 返回常规赋值器。常规赋值器无状态
    public var general: GeneralValuator {
        get { read(valuatorType: GeneralValuator.self, conditionType: .none) }
    }
    
    /// 返回背景赋值器。并指定背景颜色
    @discardableResult
    public func background(_ color: UIColor = .white) -> BackgroundValuator {
        let valuator = read(valuatorType: BackgroundValuator.self, conditionType: .none)
        return valuator.color(color)
    }
    
    /// 返回阴影赋值器。并指定阴影颜色
    @discardableResult
    public func shadow(_ color: UIColor = .black) -> ShadowValuator {
        let valuator = read(valuatorType: ShadowValuator.self, conditionType: .none)
        return valuator.color(color)
    }
    
    /// 返回指定状态的文本赋值器。并指定标题
    /// - Parameter state: 指定的状态
    @discardableResult
    public func text(_ text: String? = nil, for state: UIControl.State = .normal) -> TextValuator {
        let valuator = read(valuatorType: TextValuator.self, conditionType: .state(state))
        return valuator.text(text)
    }
    
    /// 返回指定状态的图片赋值器。并指定图片
    /// - Parameter state: 指定的状态
    @discardableResult
    public func image(_ image: UIImage?, for state: UIControl.State = .normal) -> ImageValuator {
        let valuator = read(valuatorType: ImageValuator.self, conditionType: .state(state))
        if let image = image { return valuator.image(image) }
        return valuator
    }
    
    /// 返回指定状态的图片赋值器。并指定背景图片
    /// - Parameter state: 指定的状态
    @discardableResult
    public func backgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> ImageValuator {
        let valuator = read(valuatorType: ImageValuator.self, conditionType: .state(state))
        if let image = image { return valuator.backgroundImage(image) }
        return valuator
    }
    
    /// 返回指定状态的事件赋值器。事件赋值器支持多状态
    /// - Parameter state: 指定的状态
    @discardableResult
    public func event(_ event: UIControl.Event = .touchUpInside, for target: AnyObject,
               action: Selector) -> EventValuator
    {
        let valuator = read(valuatorType: EventValuator.self, conditionType: .event(event))
        return valuator.target(target, action: action)
    }
    
    // MARK: -- 赋值器管理
    
    /// 更新指定条件的赋值器
    /// - Parameter valuator: 赋值器类型
    /// - Parameter conditionType: 条件类型
    internal func update(valuator: Valuator, conditionType: ConditionType) {
        if let existedValuator = find(valuatorType: type(of: valuator),
                                      coditionType: conditionType)
        {
            if let index = valuators.firstIndex(of: existedValuator)
            { valuators.remove(at: index) }
        }
        valuators.append(valuator)
    }
    
    /// 获取指定条件的赋值器，如果不存在则会自动创建
    /// - Parameter valuatorType: 赋值器类型
    /// - Parameter conditionType: 条件类型
    internal func read<T: Valuator>(valuatorType: T.Type, conditionType: ConditionType) -> T {
        var valuator = find(valuatorType: valuatorType, coditionType: conditionType)
        if valuator == nil {
            valuator = T(condition: conditionType)
            valuators.append(valuator!)
        }
        return valuator!
    }
    
    /// 查找指定条件的赋值器是否存在
    /// - Parameter valuatorType: 赋值器类型
    /// - Parameter coditionType: 条件类型
    internal func find<T: Valuator>(valuatorType: T.Type, coditionType: ConditionType) -> T? {
        for item in valuators {
            guard item is T else { continue }
            if item.isDuplicate(type: coditionType) { return item as? T }
        }
        return nil
    }
    
    internal func clear() {
        valuators.removeAll()
    }
}


// MARK: - 生成控件的实例方法扩展
extension Designator {
    func addView(_ view: ValuationViewProtocol, to superView: UIView?) -> ValuationViewProtocol {
        superView?.addSubview(view)
        self.applyValuator(toView: view)
        return view
    }
    
    public func makeView(toView: UIView? = nil) -> MoeView {
        return addView(MoeView(frame: .zero), to: toView) as! MoeView
    }
    
    public func makeLabel(toView: UIView? = nil) -> MoeLabel {
        return addView(MoeLabel(frame: .zero), to: toView) as! MoeLabel
    }
    
    public func makeButton(toView: UIView? = nil) -> MoeButton {
        return addView(MoeButton(type: .system), to: toView) as! MoeButton
    }
    
    public func makeImageView(toView: UIView? = nil) -> MoeImageView {
        return addView(MoeImageView(frame: .zero), to: toView) as! MoeImageView
    }
}


// MARK: - 生成控件的类方法扩展
extension Designator {
    static func addView(
        _ view: ValuationViewProtocol,
        to superView: UIView?,_ closure: DesignClosure?
    ) -> ValuationViewProtocol {
        superView?.addSubview(view)
        
        let designator = Designator()
        closure?(designator)
        designator.applyValuator(toView: view)
        
        return view
    }
    
    public static func makeView(toView: UIView? = nil, _ closure: DesignClosure? = nil) -> MoeView {
        return addView(MoeView(frame: .zero), to: toView, closure) as! MoeView
    }
    
    public static func makeLabel(toView: UIView? = nil, _ closure: DesignClosure? = nil) -> MoeLabel {
        return addView(MoeLabel(frame: .zero), to: toView, closure) as! MoeLabel
    }
    
    public static func makeButton(toView: UIView? = nil, _ closure: DesignClosure? = nil) -> MoeButton {
        return addView(MoeButton(type: .custom), to: toView, closure) as! MoeButton
    }
    
    public static func makeImageView(toView: UIView? = nil, _ closure: DesignClosure? = nil) -> MoeImageView {
        return addView(MoeImageView(frame: .zero), to: toView, closure) as! MoeImageView
    }
}

