//
//  ContactCell.swift
//  MoePageMenuDemo
//
//  Created by Zed on 2019/5/24.
//  Copyright © 2019 www.moemone.com. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoImageView.layer.cornerRadius = 15
    }
    
}
