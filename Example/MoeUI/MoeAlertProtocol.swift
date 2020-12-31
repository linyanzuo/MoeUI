//
//  MoeAlertProtocol.swift
//  MoeUI_Example
//
//  Created by Zed on 2020/12/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit


protocol MoeAlertProtocol where Self: UIViewController {
    func prepareForAlert()
}


extension MoeAlertProtocol {
    func prepareForAlert() {
        view.backgroundColor = .clear
    }
}
