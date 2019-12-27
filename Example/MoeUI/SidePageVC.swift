//
//  SidePageVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/7/31.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI
import MoeCommon


class SidePageVC: UITableViewController {

    class func storyboardInstance() -> SidePageVC? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NSStringFromClass(self.classForCoder())) as? SidePageVC
    }
    
    deinit {
        MLog("SidePageVC Died!")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.backgroundColor = UIColor.yellow
        self.tableView.backgroundColor = UIColor.yellow

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.view.addGestureRecognizer(tap)

        self.navigationItem.title = "SidePage"
        let btn = UIButton(type: .contactAdd)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MLog("SidePageVC View Did Load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MLog("SidePageVC View Will Appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MLog("SidePageVC View Did Appear")
    }

    @objc private func tapAction() {
//        self.dismiss(animated: true, completion: nil)

        let otherVC = OtherVC()
        self.drawerPush(otherVC)
    }
}
