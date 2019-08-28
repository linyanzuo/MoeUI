//
//  ImageAttributer.swift
//  MoeUI
//
//  Created by Zed on 2019/8/3.
//

import UIKit


internal struct ImageAttribute {
    internal var image: UIImage?
    internal var cornerRadius: CGFloat?
    internal var state: UIControl.State?
    internal var type: ImageType = .content

    enum ImageType {
        case background
        case content
    }
}


public class ImageAttributer: AppearanceAttributer, Codable {
    @discardableResult
    public func image(_ image: UIImage, state: UIControl.State = .normal) -> Self {
        attribute.image = image
        attribute.state = state
        attribute.type = .content
        return self
    }

    @discardableResult
    public func backgroundImage(_ image: UIImage, state: UIControl.State = .normal) -> Self {
        attribute.image = image
        attribute.state = state
        attribute.type = .background
        return self
    }

    @discardableResult
    public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        if cornerRadius > 0.0 { attribute.cornerRadius = cornerRadius }
        return self
    }

    // MARK: Getter & Setter
    private(set) lazy var attribute: ImageAttribute = { return ImageAttribute() }()
}
