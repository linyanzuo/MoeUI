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
    private let sectionSource: [[String]] = [
        [("View ShowSuccess"),
         ("View ShowError"),
         ("View ShowProgress"),
         ("View ShowToast"),
         ("View ShowCustom")],
        [("Window ShowSuccess"),
         ("Window ShowError"),
         ("Window ShowProgress"),
         ("Window ShowToast"),
         ("Window ShowCustom")],
        [("Controller ShowSuccess"),
         ("Controller ShowError"),
         ("Controller ShowProgress"),
         ("Controller ShowToast")]
    ]

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
        tableView.moe.registerCells(cellClasses: [TitleCell.self])
    }

    // MARK: -- UITableViewDelegate & UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let indexSource = sectionSource[section]
        return indexSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titles = sectionSource[indexPath.section]
        let title = titles[indexPath.row]

        let cell = tableView.moe.dequeueCell(cellClass: TitleCell.self)
        cell.titleLabel.text = title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            MLog("UIView形式的弹窗展示")
            switch indexPath.row {
            case 0:
                let dialog = AlertDialog(style: .success, text: "祝贺您，操作已成功")
                Alerter.show(dialog, in: self.view.window!, with: "Paying", maskEnable: true)
            case 1:
                let dialog = AlertDialog(style: .error, text: "很不幸，并没有生效")
                Alerter.show(dialog, in: self.view.window!, with: "Paying", maskEnable: true)
            case 2:
                let dialog = AlertDialog(style: .progress, text: "正在处理")
                Alerter.show(dialog, in: self.view.window!, with: "Paying", maskEnable: true)
            default: MLog("Nothing")
            }
        } else if indexPath.section == 1 {
            MLog("UIWindow形式的弹窗展示")
            switch indexPath.row {
            case 0: HUD.show(style: .success, text: "Congratulation, it work!", maskEnable: true)
            case 1: HUD.show(style: .error, text: "unfortunately, it does't work!", maskEnable: true)
            case 2:
                let dialog = AlertDialog(style: .progress, text: "Loading...")
                let id = HUD.show(customView: dialog, maskEnable: true)
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
        } else if indexPath.section == 2 {
            MLog("UIViewController形式的弹窗展示")
            switch indexPath.row {
            case 0:
                let vc = StyleAlertController(style: .success, text: "祝贺您，操作已成功")
                vc.moe.clearPresentationBackground()
                moe.present(viewController: vc)
            case 1:
                let vc = StyleAlertController(style: .error, text: "很不幸，并没有生效")
                moe.present(viewController: vc)
            case 2:
                let vc = StyleAlertController(style: .progress, text: "正在处理")
                moe.present(viewController: vc)
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
