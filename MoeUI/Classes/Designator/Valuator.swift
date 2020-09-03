//
//  Valuator.swift
//  MoeUIDemo
//
//  Created by Zed on 2019/11/22.
//  Copyright © 2019 www.moemone.com. All rights reserved.
//

import UIKit


/// 赋值协议。赋值器在该协议方法实现中完成对不同控件的赋值
public protocol ValuatorProtocol {
    func apply(to view: ValuationViewProtocol)
}


/// 赋值器类型
public enum ValuatorType {
    case general(GeneralValuator)
    case background(BackgroundValuator)
    case shadow(ShadowValuator)
    case text(TextValuator)
    case image(ImageValuator)
    case event(EventValuator)
    
    /// 获取对应的赋值器实例
    public var valuator: ValuatorProtocol {
        switch self {
        case .general(let general): return general
        case .background(let background): return background
        case .shadow(let shadow): return shadow
        case .text(let text): return text
        case .image(let image): return image
        case .event(let event): return event
        }
    }
}


/// 赋值条件类型
enum ConditionType {
    /// 无条件，根据类型判断是否为重复
    case none
    /// 状态条件，根据类型及状态判断是否为重复
    case state(UIControl.State)
    /// 事件条件，根据类型及事件判断是否为重复
    case event(UIControl.Event)
}


/// 赋值器基类，负责为控件的相应属性赋值
public class Valuator: ValuatorProtocol, Equatable {
    required init(condition: ConditionType) {
        self.condition = condition
    }
    
    /// 条件类型，用于判断赋值器是否重复
    private(set) var condition: ConditionType
    
    /// 根据赋值条件类型，判断条件是否相同
    /// - Parameter type: 赋值条件类型
    func isDuplicate(type: ConditionType) -> Bool { return false }
    
    /// 将赋值器应用至控件上，为控件的相应属性赋值
    /// - Parameter control: 目标控件
    public func apply(to view: ValuationViewProtocol) { }
    
    /// 比较两个赋值器实例是否相同
    /// - Parameter lhs: 源赋值器实例
    /// - Parameter rhs: 目标赋值器实例
    public static func == (lhs: Valuator, rhs: Valuator) -> Bool {
        return lhs === rhs
    }
}


// MARK: 无条件赋值器

/// 无条件赋值器基类
public class NoneValuator: Valuator {
    required init() { super.init(condition: .none) }
    
    required init(condition: ConditionType) {
        switch condition {
        case .none:
            super.init(condition: .none)
        default: fatalError("init(condition:) has not been implemented")
        }
    }
    
    override func isDuplicate(type: ConditionType) -> Bool {
        switch type {
        case .none: return true
        default: return false
        }
    }
}


// MARK: --- 常规赋值器

/// 常规赋值器。负责视图常规的赋值，如位置、尺寸、启用交互、透明度等
public class GeneralValuator: NoneValuator {
    internal var frame: CGRect?
    internal var alpha: CGFloat?
    internal var userInterfaceEnable: Bool?
    
    override public func apply(to view: ValuationViewProtocol) {
        view.applyValuation(valuatorType: .general(self))
    }
    
    // MARK: 链式赋值方法
    
    @discardableResult
    public func frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }

    @discardableResult
    public func alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }

    @discardableResult
    public func userInterfaceEnable(_ enable: Bool) -> Self {
        self.userInterfaceEnable = enable
        return self
    }
}


// MARK: --- 背景赋值器

/// 背景赋值器。负责视图背景的赋值，支持纯色、渐变色、圆角(支持不离屏)、边框等
public class BackgroundValuator: NoneValuator {
    private(set) var color: UIColor = .white
    private(set) var cornerRadius: CGFloat?
    private(set) var maskColor: UIColor?
    private(set) var isMaskCornerRadius: Bool?
    private(set) var border: BackgroundBorder?
    private(set) var gradient: BackgroundGradient?
    
    internal struct BackgroundBorder {
        internal var width: CGFloat?
        internal var color: UIColor?
    }
    
    internal struct BackgroundGradient {
        internal var startPoint: CGPoint
        internal var endPoint: CGPoint
        internal var colors: [UIColor]
        internal var locations: [NSNumber]
    }
    
    public convenience init(color: UIColor) {
        self.init()
        self.color = color
    }
    
    override public func apply(to view: ValuationViewProtocol) {
        view.applyValuation(valuatorType: .background(self))
    }
    
    // MARK: 链式赋值方法
    
    @discardableResult
    public func color(_ color: UIColor) -> Self {
        self.color = color
        return self
    }

    @discardableResult
    public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.isMaskCornerRadius = false
        if cornerRadius > 0.0 { self.cornerRadius = cornerRadius }
        return self
    }

    @discardableResult
    public func maskCornerRadius(_ cornerRadius: CGFloat, maskColor: UIColor) -> Self {
        guard cornerRadius > 0 else { return self }
        self.isMaskCornerRadius = true
        self.maskColor = maskColor
        self.cornerRadius = cornerRadius
        return self
    }

    @discardableResult
    public func border(_ width: CGFloat, color: UIColor = UIColor.black) -> Self {
        self.border = BackgroundBorder(width: width, color: color)
        return self
    }

    @discardableResult
    public func gradient(
        startPoint: CGPoint,
        endPoint: CGPoint,
        colors: [UIColor],
        locations: [NSNumber]
    ) -> Self {
        self.gradient = BackgroundGradient(
            startPoint: startPoint,
            endPoint: endPoint,
            colors: colors,
            locations: locations
        )
        return self
    }
}


// MARK: --- 阴影赋值器

/// 阴影赋值器。负责视图阴影的赋值，支持颜色、圆角、透明度、偏移、路径、延伸等
public class ShadowValuator: NoneValuator {
    internal var color: UIColor = .black
    internal var opacity: Float?
    internal var cornerRadius: CGFloat?
    internal var offset: CGSize?
    internal var extend: CGSize?
    internal var path: CGPath?
    
    public convenience init(color: UIColor) {
         self.init()
         self.color = color
    }
    
    override public func apply(to view: ValuationViewProtocol) {
        view.applyValuation(valuatorType: .shadow(self))
    }
    
    // MARK: 链式赋值方法
    
    @discardableResult
    public func opacity(_ opacity: Float) -> Self {
        self.opacity = opacity
        return self
    }

    @discardableResult
    public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.cornerRadius = cornerRadius
        return self
    }

    @discardableResult
    public func offset(_ offset: CGSize) -> Self {
        self.offset = offset
        return self
    }

    @discardableResult
    public func extend(_ extend: CGSize) -> Self {
        self.extend = extend
        return self
    }

    @discardableResult
    public func color(_ color: UIColor) -> Self {
        self.color = color
        return self
    }

    @discardableResult
    public func path(_ path: CGPath) -> Self {
        self.path = path
        return self
    }
}


// MARK: 状态条件赋值器

/// 状态赋值器基类，支持为多状态视图配置不同状态的属性值
public class StateValuator: Valuator {
    required init(state: UIControl.State = .normal) {
        self.state = state
        super.init(condition: .state(state))
    }
    
    required init(condition: ConditionType) {
        switch condition {
        case .state(let state):
            self.state = state
            super.init(condition: condition)
        default: fatalError("init(condition:) has not been implemented")
        }
    }
    
    /// 赋值器的状态值
    private(set) var state: UIControl.State = .normal
    
    override func isDuplicate(type: ConditionType) -> Bool {
        switch type {
        case .state(let state):
            if self.state == state { return true }
            return false
        default: return false
        }
    }
}


// MARK: -- 文本赋值器

/// 文本赋值器。负责视图文本的赋值，支持内容、字体、颜色、对齐方式、状态等
public class TextValuator: StateValuator {
    internal var text: String?
    internal var font: UIFont = UIFont.systemFont(ofSize: 15)
    internal var color: UIColor = .black
    internal var numberOfLines: Int = 1
    internal var firstLineIndent: CGFloat?
    internal var alignment: NSTextAlignment?
    
    public convenience init(text: String) {
        self.init()
        self.text = text
    }
    
    override public func apply(to view: ValuationViewProtocol) {
        view.applyValuation(valuatorType: .text(self))
    }
    
    // MARK: 链式赋值方法
    
    @discardableResult
    public func text(_ text: String?) -> Self {
        if let text = text { self.text = text }
        return self
    }

    @available (iOS 9.0, *)
    @discardableResult
    public func font(_ size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        return self
    }

    @discardableResult
    public func color(_ color: UIColor) -> Self {
        self.color = color
        return self
    }

    @discardableResult
    public func color(_ rgb: UInt32) -> Self {
        return self.color(UIColor(rgb: rgb))
    }

    @discardableResult
    public func lines(_ number: Int) -> Self {
        self.numberOfLines = number
        return self
    }

    @discardableResult
    public func firstLineIndent(_ indent: CGFloat) -> Self {
        self.firstLineIndent = indent
        return self
    }

    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        self.alignment = alignment
        return self
    }
}


// MARK: -- 图片赋值器

/// 图片赋值器。负责视图图片的赋值，支持图片、圆角(支持不离屏)等
public class ImageValuator: StateValuator {
    
    override public func apply(to view: ValuationViewProtocol) {
        view.applyValuation(valuatorType: .image(self))
    }
    
    internal var image: UIImage?
    internal var backgroundImage: UIImage?
    internal var cornerRadius: CGFloat?
    internal var maskColor: UIColor?
    internal var isMaskCornerRadius: Bool?
    
    public convenience init(image: UIImage) {
        self.init()
        self.image = image
    }
    
    // MARK: 链式赋值方法
    
    @discardableResult
    public func image(_ image: UIImage) -> Self {
        self.image = image
        return self
    }
    
    @discardableResult
    public func backgroundImage(_ image: UIImage) -> Self {
        self.backgroundImage  = image
        return self
    }

    @discardableResult
    public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        if cornerRadius > 0.0 { self.cornerRadius = cornerRadius }
        return self
    }

    @discardableResult
    public func maskCornerRadius(_ cornerRadius: CGFloat, maskColor: UIColor) -> Self {
        guard cornerRadius > 0 else { return self }
        self.isMaskCornerRadius = true
        self.maskColor = maskColor
        self.cornerRadius = cornerRadius
        return self
    }
}


// MARK: 事件赋值器

public class EventValuator: Valuator {
    private(set) var event: UIControl.Event
    internal weak var target: AnyObject?
    internal var action: Selector?
    
    required init(event: UIControl.Event) {
        self.event = event
        super.init(condition: .event(event))
    }
    
    required init(condition: ConditionType) {
        switch condition {
        case .event(let event):
            self.event = event
            super.init(condition: .event(event))
        default: fatalError("init(condition:) has not been implemented")
        }
    }
    
    override func isDuplicate(type: ConditionType) -> Bool {
        switch type {
        case .event(let event):
            return self.event == event
        default: return false
        }
    }
    
    override public func apply(to view: ValuationViewProtocol) {
        view.applyValuation(valuatorType: .event(self))
    }
    
    // MARK: 链式赋值方法
    
    @discardableResult
    public func target(_ target: AnyObject, action: Selector) -> Self {
        self.target = target
        self.action = action
        return self
    }
}
