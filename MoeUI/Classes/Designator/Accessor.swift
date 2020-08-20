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


/// 存取器。负责对“赋值器或设计器”进行“寄存或索取”操作
public class Accessor {
    /// 获取暂存器的共享实例
    static public let shared = Accessor()
    private init() {}
    
    private(set) lazy var designators = { return [DesignatorID: Designator]() }()
    private(set) lazy var valuators = { return [ValuatorID: Valuator]() }()
    
    public class func generateID() -> String {
        return UUID().uuidString
    }
    
    // MARK: 设计器相关
    
    /// 判断ID值是否已被设计器注册，已注册返回`true`，反之亦然
    /// - Parameter designatorID: 要判断的ID值
    public func isRegistered(designatorID: DesignatorID) -> Bool {
        return designators.keys.contains(designatorID)
    }
    
    /// 使用ID注册关联的设计器，成功返回关联的`ID`、失败返回`nil`
    /// - Parameter designator: 要注册的设计器
    /// - Parameter id: 关联的ID值，为nil时则自动生成ID值
    @discardableResult
    public func register(designator: Designator, for id: DesignatorID? = nil) -> DesignatorID? {
        let id = id ?? Self.generateID()
        guard isRegistered(designatorID: id) == false else { return nil }
        
        designators.updateValue(designator, forKey: id)
        return id
    }
    
    /// 获取ID关联的设计器，成功返回设计器实例、失败返回`nil`
    /// - Parameter designatorID: 设计器关联的ID值
    public func dequeue(designatorWith designatorID: DesignatorID) -> Designator? {
        if isRegistered(designatorID: designatorID) == false { return nil }
        return designators[designatorID]
    }
    
    // MARK: 赋值器相关
    
    /// 判断ID值是否已被赋值器注册，已注册返回`true`，反之亦然
    /// - Parameter valuatorID: 要判断的ID值
    public func isRegistered(valuatorID: ValuatorID) -> Bool {
        return valuators.keys.contains(valuatorID)
    }
    
    /// 使用ID注册关联的赋值器，成功返回关联的`ID`、失败返回`nil`
    /// - Parameter valuator: 要注册的赋值器
    /// - Parameter id: 关联的ID值，为nil时则自动生成ID值
    @discardableResult
    public func register(valuator: Valuator, for id: DesignatorID? = nil) -> ValuatorID? {
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

