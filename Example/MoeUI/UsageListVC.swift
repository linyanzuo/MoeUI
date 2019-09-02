//
//  TutorialListVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/8/31.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI


class UsageListVC: UITableViewController {
    private let kUsageCellReuseID = "UsageCellReuseIdentifier"
    private let usages: [(title: String, clazzName: String)] = [
        ("Appearance Usage", "AppearanceVC"),
        ("Appearance Registration Usage", "RegistrationVC"),
    ]

    // MARK: Object Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(style: .plain)
        setupSelf()
    }

    private func setupSelf() {
        self.title = "MoeUI"
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: kUsageCellReuseID)
    }

    // MARK: Delegate Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kUsageCellReuseID)
        let data = usages[indexPath.row]

        cell!.textLabel?.text = data.title

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let targetVC = AppearanceVC.storyboardInstance()
            self.navigationController?.pushViewController(targetVC, animated: true)
        } else {
            let data = usages[indexPath.row]
            pushToTargetClass(with: data.clazzName)
        }
    }

    // MARK: Private Method
    private func pushToTargetClass(with clazzName: String) {
        guard let clazz: AnyClass = NSClassFromString(MInfo.namespace + "." + clazzName)
            else { return }

        guard let vcClazz = clazz as? UIViewController.Type
            else { return }

        let targetVC = vcClazz.init()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
}
