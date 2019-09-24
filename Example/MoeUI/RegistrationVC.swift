//
//  RegistrationVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/9/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI


class RegistrationVC: UITableViewController {
    /// Register Appearance in `AppDelegate+Appearance`

    let settingGroup: [[SettingData]] = [
        [
            ImageSetting(title: "头像", image: UIImage(named: "Lambert")!, position: .right),
            DetailSetting(title: "昵称", detail: "海洋中发怒的公主")
        ], [
            DetailSetting(title: "语言切换", detail: "中文简体"),
            TitleSetting(title: "清除缓存", isArrowShow: false),
        ], [
            SwitchSetting(title: "推送通知", isOn: true)
        ], [
            DetailSetting(title: "绑定手机号", detail: "173****2097"),
            TitleSetting(title: "修改登录密码", isArrowShow: true),
            TitleSetting(title: "修改支付密码", isArrowShow: true)
        ], [
            ImageSetting(title: "帐单", image: UIImage(named: "personal_icon_bill")!, position: .left),
            ImageSetting(title: "帐户", image: UIImage(named: "personal_icon_Alipay")!, position: .left),
        ]
    ]
    let kSettingCellReuseID = "SettingCellReuseID"

    // MARK: Object Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableView.Style) {
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.register(SettingCell.classForCoder(), forCellReuseIdentifier: kSettingCellReuseID)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingGroup.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let settings = settingGroup[section]
        return settings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settings = settingGroup[indexPath.section]
        let setting = settings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: kSettingCellReuseID) as! SettingCell
        cell.setData(setting)
        cell.setSeparator(isShow: true, inset: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))

        return cell
    }
}
