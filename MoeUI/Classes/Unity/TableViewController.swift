//
//  Created by Zed on 2019/7/18.
//  Copyright © 2019 www.moemone.com. All rights reserved.
//

import UIKit
import MoeCommon


/// 表格视图控制器基类
open class TableViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    private var tableStyle: UITableView.Style
    
    public init(style: UITableView.Style) {
        self.tableStyle = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("「TableViewController」的子类必须重写「tableView(_, cellForRowAt)」方法，不需要执行「super」")
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    open private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: tableStyle)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        view.addSubview(tableView)
        return tableView;
    }()
}
