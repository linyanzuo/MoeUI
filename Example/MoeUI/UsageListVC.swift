//
//  SideMainVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/7/31.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI
import MoeCommon


class UsageListVC: TableViewController {
    
    // MARK: Property
    
    private let usagesGroup: [[(title: String, clazzName: String)]] = [
        [("Designator - 样式设计", "AppearanceVC"),
         ("Accessor - 样式注册", "RegistrationVC")],
        [("BlurLabel - 文字模糊", "TextBlurViewController")]
    ]
    private let kTitleCellReuseID = "TitleCellReuseID"
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()

        self.title = "MoeUI"
        self.tableView.register(TitleCell.self, forCellReuseIdentifier: kTitleCellReuseID)
    }
    
    // MARK: Navigation
    
    override func setupNavigation() {
        self.navigationItem.title = "Main"
        let btn = UIButton(type: .contactAdd)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    @objc private func btnAction() {
        let pageVC = SidePageVC.storyboardInstance()!
        self.drawerPresentSide(pageVC)
    }

    // MARK: Delegate Method
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return usagesGroup.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let usages = usagesGroup[section]
        return usages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let usages = usagesGroup[indexPath.section]
        let usage = usages[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: kTitleCellReuseID) as! TitleCell
        cell.titleLabel.text = usage.title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usages = usagesGroup[indexPath.section]
        let usage = usages[indexPath.row]

        if indexPath.section == 0 && indexPath.row == 0 {
            let targetVC = AppearanceVC.storyboardInstance()
            self.navigationController?.pushViewController(targetVC!, animated: true)
        } else {
            pushToTargetClass(with: usage.clazzName)
        }
    }

    // MARK: Private Method
    
    @discardableResult
    private func pushToTargetClass(with clazzName: String) -> Bool {
        let namespace = InfoPlist.namespace
        guard let clazz: AnyClass = NSClassFromString(namespace + "." + clazzName)
            else { return false }

        guard let vcClazz = clazz as? UIViewController.Type
            else { return false }

        let targetVC = vcClazz.init()
        self.navigationController?.pushViewController(targetVC, animated: true)
        return true
    }
}
