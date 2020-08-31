//
//  Registor.swift
//  MoeUIDemo
//
//  Created by Zed on 2019/11/26.
//  Copyright © 2019 www.moemone.com. All rights reserved.
//

import UIKit


public typealias DesignatorID = String
public typealias ValuatorID = String
public typealias DesignClosure = (_ designator: Designator) -> Void


// MARK: - 存取器。负责对“赋值器或设计器”进行“寄存或索取”操作
public class Accessor {
    /// 获取存取器的共享实例
    static public let shared = Accessor()
    private init() {}
    
    private(set) lazy var designators = { return [DesignatorID: Designator]() }()
    private(set) lazy var valuators = { return [ValuatorID: Valuator]() }()
    
    public class func generateID() -> String {
        return UUID().uuidString
    }
}


// MARK: - 设计器相关扩展
extension Accessor {
    /// 判断ID值是否已被设计器注册，已注册返回`true`，反之亦然
    /// - Parameter designatorID: 要判断的ID值
    public func isRegistered(designatorID: DesignatorID) -> Bool {
        return designators.keys.contains(designatorID)
    }
    
    /// 注册设计器，注册成功返回关联的`ID`、失败返回`nil`
    /// - Parameters:
    ///   - designator: 设计器实例
    ///   - id:         关联的ID值，为nil时（没有指定）则自动生成
    /// - Returns:      设计器实例注册成功后关联的ID值，若注册失败则返回nil
    @discardableResult
    public func register(id: DesignatorID? = nil, designator: Designator) -> DesignatorID? {
        let id = id ?? Self.generateID()
        guard isRegistered(designatorID: id) == false else { return nil }
        
        designators.updateValue(designator, forKey: id)
        return id
    }
    
    /// 注册设计器，注册成功返回关联的`ID`、失败返回`nil`
    /// - Parameters:
    ///   - id:         关联的ID值，为nil时（没有指定）则自动生成
    ///   - closure:    设计器配置闭包，在此闭包中完成对设计器的配置
    /// - Returns:      设计器实例注册成功后关联的ID值，若注册失败则返回nil
    @discardableResult
    public func register(id: DesignatorID? = nil, closure: DesignClosure) -> DesignatorID? {
        let designator = Designator()
        closure(designator)
        
        return register(id: id, designator: designator)
    }
    
    /// 获取ID关联的设计器，成功返回设计器实例、失败返回`nil`
    /// - Parameter designatorID: 设计器关联的ID值
    public func dequeue(designatorWith designatorID: DesignatorID) -> Designator? {
        if isRegistered(designatorID: designatorID) == false { return nil }
        return designators[designatorID]
    }
}


// MARK: - 赋值器相关扩展
extension Accessor {
    /// 判断ID值是否已被赋值器注册，已注册返回`true`，反之亦然
    /// - Parameter valuatorID: 要判断的ID值
    public func isRegistered(valuatorID: ValuatorID) -> Bool {
        return valuators.keys.contains(valuatorID)
    }
    
    /// 注册赋值器，成功返回关联的`ID`、失败返回`nil`
    /// - Parameter valuator:   赋值器实例
    /// - Parameter id:         关联的ID值，为nil时（没有指定）则自动生成
    /// - Returns:              赋值器实例注册成功后关联的ID值，若注册失败则返回nil
    @discardableResult
    public func register(id: DesignatorID? = nil, valuator: Valuator) -> ValuatorID? {
        let id = id ?? Self.generateID()
        guard isRegistered(valuatorID: id) == false else { return nil }
        
        valuators.updateValue(valuator, forKey: id)
        return id
    }
    
    /// 判断ID值是否已被赋值器注册，已注册返回`true`，反之亦然
    /// - Parameter valuatorID: 赋值器关联的ID值
    public func dequeue(valuatorWith valuatorID: ValuatorID) -> Valuator? {
        if isRegistered(valuatorID: valuatorID) == false { return nil }
        return valuators[valuatorID]
    }
}


// MARK: - 生成控件的类方法扩展
extension Accessor {
    public static func makeView(toView: UIView? = nil, with id: DesignatorID) -> MoeView? {
        return Accessor.shared.dequeue(designatorWith: id)?.makeView(toView: toView)
    }
    
    public static func makeLabel(toView: UIView? = nil, with id: DesignatorID) -> MoeLabel? {
        return Accessor.shared.dequeue(designatorWith: id)?.makeLabel(toView: toView)
    }
    
    public static func makeButton(toView: UIView? = nil, with id: DesignatorID) -> MoeButton? {
        return Accessor.shared.dequeue(designatorWith: id)?.makeButton(toView: toView)
    }
    
    public static func makeImageView(toView: UIView? = nil, with id: DesignatorID) -> MoeImageView? {
        return Accessor.shared.dequeue(designatorWith: id)?.makeImageView(toView: toView)
    }
}
