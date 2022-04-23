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
        debugPrint("SidePageVC Died!")
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
        
        debugPrint("SidePageVC View Did Load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        debugPrint("SidePageVC View Will Appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        debugPrint("SidePageVC View Did Appear")
    }

    @objc private func tapAction() {
//        self.dismiss(animated: true, completion: nil)

        let otherVC = OtherVC()
        self.drawerPush(otherVC)
    }
}
