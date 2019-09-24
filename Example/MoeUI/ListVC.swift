//
//  ListVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/7/24.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class ListVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.backgroundColor = UIColor.white
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "CornerRadiusCellReuseID") as! CornerRaidusCell

        cell.iconImgView?.image = UIImage(named: "Lambert")
        cell.titleLab.text = "Hello word"
        cell.tagLab.text = " Artist "

        return cell
    }
}
