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
    private let usagesGroup: [[(title: String, clazzName: String)]] = [
        [
            ("Appearance", "AppearanceVC"),
            ("Appearance Registration", "RegistrationVC"),
        ], [
            ("HUD  &  Alert", "AlertUsageVC")
        ]
    ]
    private let kTitleCellReuseID = "TitleCellReuseID"

    // MARK: Object Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewStyle) {
        super.init(style: .grouped)
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "MoeUI"
        self.tableView.register(TitleCell.classForCoder(), forCellReuseIdentifier: kTitleCellReuseID)
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
            self.navigationController?.pushViewController(targetVC, animated: true)
        } else {
            pushToTargetClass(with: usage.clazzName)
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
