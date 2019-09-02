//
//  ProgressAlertController.swift
//  MoeUI
//
//  Created by Zed on 2019/9/2.
//

import UIKit


public class ProgressAlertController: MaskAlertController {

    var style: AlertDialog.Style
    var text: String

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(style: AlertDialog.Style, text: String) {
        self.style = style
        self.text = text
        super.init()
    }

    override public func viewToAlert() -> UIView {
        return AlertDialog(style: style, text: text)
    }
}
