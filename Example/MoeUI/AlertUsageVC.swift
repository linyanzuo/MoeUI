//
//  HUDUsageVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/9/18.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI
import MoeCommon


class AlertUsageVC: UITableViewController {
    private let datasources: [[String]] = [
        [("HUD ShowSuccess"),
         ("HUD ShowError"),
         ("HUD ShowProgress"),
         ("HUD ShowToast"),
         ("HUD ShowCustom")],
        [("MaskAlertController")]
    ]
    private let kReuseID = "TitleCellResueID"

    // MARK: Object Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableView.Style) {
        super.init(style: .grouped)
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.register(TitleCell.self, forCellReuseIdentifier: kReuseID)
    }

    // MARK: -- UITableViewDelegate & UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return datasources.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let titles = datasources[section]
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titles = datasources[indexPath.section]
        let title = titles[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: kReuseID) as! TitleCell
        cell.titleLabel.text = title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: HUD.show(style: .success, text: "Configuration, it work!")
            case 1: HUD.show(style: .error, text: "unfortunately, it does't work!")
            case 2:
                let dialog = AlertDialog(style: .progress, text: "Loading...")
                let id = HUD.show(customView: dialog)
                DispatchQueue.global().async {
                    self.doSomework()
                    DispatchQueue.main.async { HUD.hide(with: id) }
                }
            case 3: HUD.show(style: .toast, text: "Message here!")
            case 4:
                let customDialog = CustomDialog()
                let id = HUD.show(customView: customDialog)

                DispatchQueue.global().async {
                    self.doSomework()
                    DispatchQueue.main.async { HUD.hide(with: id) }
                }
            default: MLog("Nothing")
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let vc = ProgressAlertController(style: .progress, text: "正在处理")
                self.present(vc, animated: true, completion: nil)
            default: MLog("Nothing")
            }
        }
    }

    // MARK: Others
    func doSomework() {
        // 模拟耗时操作
        sleep(3)
    }
}
