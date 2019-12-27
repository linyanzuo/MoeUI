//
//  OtherVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/8/7.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI
import MoeCommon


class OtherVC: UIViewController {
    
    deinit {
        MLog("OtherVC Died!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        MLog("OtherVC View Did Load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MLog("OtherVC View Will Appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MLog("OtherVC View Did Appear")
    }

}
