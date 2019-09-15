//
//  EventAttributer.swift
//  MoeUI
//
//  Created by Zed on 2019/8/29.
//

import UIKit


internal class EventAttribute: AppearanceAttribute {
    internal weak var target: AnyObject?
    internal var action: Selector?
    internal var controlEvents: UIControl.Event?
}


public class EventAttributer: AppearanceAttributer, Codable {
    @discardableResult
    public func target(target: AnyObject) -> Self {
        attribute.target = target
        return self
    }

    @discardableResult
    public func action(_ action: Selector, for controlEvents: UIControl.Event) -> Self {
        attribute.action = action
        attribute.controlEvents = controlEvents
        return self
    }

    // MARK: Getter & Setter
    private(set) lazy var attribute: EventAttribute = { return EventAttribute() }()
}
