//
//  SidePageVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/7/31.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class SidePageVC: UIViewController {

    class func storyboardInstance() -> SidePageVC? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NSStringFromClass(self.classForCoder())) as? SidePageVC
    }

    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.view.addGestureRecognizer(tap)
    }

    @objc private func tapAction() {
        self.dismiss(animated: true, completion: nil)
    }
}
