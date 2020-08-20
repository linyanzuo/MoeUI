//
//  ContactViewController.swift
//  MoePageMenuDemo
//
//  Created by Zed on 2019/5/24.
//  Copyright © 2019 www.moemone.com. All rights reserved.
//

import UIKit

class ContactViewController: UITableViewController {

    var namesArray: [String] = ["Kim White", "Kim White", "David Fletcher", "Anna Hunt", "Timothy Jones", "Timothy Jones", "Timothy Jones", "Lauren Richard", "Lauren Richard", "Juan Rodriguez"]
    var photoNameArray: [String] = ["woman1.jpg", "woman1.jpg", "man8.jpg", "woman3.jpg", "man3.jpg", "man3.jpg", "man3.jpg", "woman5.jpg", "woman5.jpg", "man5.jpg"]
    var activityTypeArray : NSArray = [0, 1, 1, 0, 2, 1, 2, 0, 0, 2]
    var dateArray: NSArray = ["4:22 PM", "Wednesday", "Tuesday", "Sunday", "01/02/15", "12/31/14", "12/28/14", "12/24/14", "12/17/14", "12/14/14"]
    
    var parentNavigationController: UINavigationController?
    let reuseID = "ContactCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: reuseID)
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID) as! ContactCell
        cell.nameLabel.text = namesArray[indexPath.row]
        cell.dateLabel.text = dateArray[indexPath.row] as! NSString as String
        cell.nameLabel.textColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC : UIViewController = UIViewController()
        newVC.view.backgroundColor = UIColor.white
        newVC.title = "New Page"
        
        parentNavigationController!.pushViewController(newVC, animated: true)
    }
    
}
