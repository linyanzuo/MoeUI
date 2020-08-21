//
//  UnitedTableViewController.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/12/27.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI
import SnapKit


/// Cell模型协议
public protocol UnitedTableCellDataProtocol {
    /// 注册Cell时的复用ID
    func reuseIdentifier() -> String
    
    func cellClass() -> UnitedTableCellProtocol.Type
}


/// Cell协议
public protocol UnitedTableCellProtocol where Self: TableViewCell {
    /// 根据模型值, 更新样式
    func updateUI(with data: UnitedTableCellDataProtocol)
}


open class UnitedTableViewController: ViewController {
    public enum Style {
        case plain([UnitedTableCellDataProtocol])
        case group([[UnitedTableCellDataProtocol]])
    }
    
    // MARK: Object life cycle
    
    private var registedReuseIDs: [String] = []
    var style: Style?
    
    override open func setupSubview() {
        style = styleDataSources()
        view.addSubview(tableView)
        registerAllCell()
        
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(topLayoutGuide.snp.top)
            maker.left.right.equalToSuperview()
            maker.bottom.equalTo(bottomLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: Subclass override
    
    open func styleDataSources() -> Style? {
        return nil
    }
    
    // MARK: Getter & Setter
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
}


// MARK: TableView

extension UnitedTableViewController: UITableViewDataSource {
    private func registerAllCell() {
        guard let style = self.style else { return }
        
        registedReuseIDs.removeAll()
        switch style {
        case .plain(let plainSources):
            for plain in plainSources { registerCell(with: plain) }
        case .group(let groupedSources):
            for plainSources in groupedSources {
                for plain in plainSources { registerCell(with: plain) }
            }
        }
    }
    
    private func registerCell(with data: UnitedTableCellDataProtocol) {
        guard registedReuseIDs.contains(data.reuseIdentifier()) == false else { return }
        
        tableView.register(data.cellClass(), forCellReuseIdentifier: data.reuseIdentifier())
        registedReuseIDs.append(data.reuseIdentifier())
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let style = self.style else { return 0 }
        
        switch style {
        case .plain(_): return 1
        case .group(let groupedSources): return groupedSources.count
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let style = self.style else { return 0 }
        
        switch style {
        case .plain(let plainSources): return plainSources.count
        case .group(let groupedSources): return groupedSources[section].count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var data: UnitedTableCellDataProtocol? = nil
        switch style! {
        case .plain(let plainSources):
            data = plainSources[indexPath.row]
        case .group(let groupedSources):
            let groupData = groupedSources[indexPath.section]
            data = groupData[indexPath.row]
        }
        
        let cellData = data!
        let cell = tableView.dequeueReusableCell(withIdentifier: cellData.reuseIdentifier())!
        if let unitedCell = cell as? UnitedTableCellProtocol {
            unitedCell.updateUI(with: cellData)
        }
        
        return cell
    }
}

