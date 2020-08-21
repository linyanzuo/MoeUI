//
//  CornerRaidusCell.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/7/24.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class CornerRaidusCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var tagLab: UILabel!
    @IBOutlet weak var rightBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        cardView.translatesAutoresizingMaskIntoConstraints = false
//        iconImgView.translatesAutoresizingMaskIntoConstraints = false
//        titleLab.translatesAutoresizingMaskIntoConstraints = false
//        tagLab.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none

        /// maskToBounds = false 时, UIView 的圆角会生效, 但不会遮挡溢出的子视图, 不会触发离屏渲染
        /// maskToBounds = true 时, UIView 的圆角会生效, 溢出的子视图被遮挡, 触发离屏渲染
        cardView.backgroundColor = UIColor.lightGray
//        cardView.layer.cornerRadius = 8
//        cardView.layer.masksToBounds = true
        cardView.layer.addCornerRadius(radius: 8)

        /// maskToBounds = false 时, UIImageView 的圆角不会生效, 不触发离屏渲染
        /// maskToBounds = true 时, UIImageView的圆角生效, 触发离屏渲染
//        iconImgView.layer.cornerRadius = 8
//        iconImgView.layer.masksToBounds = true
//        iconImgView.addCornerRadius(16)
        iconImgView.layer.addCornerRadius(radius: 16, maskColor: UIColor.lightGray)

        tagLab.backgroundColor = UIColor.red
//        tagLab.layer.masksToBounds = false
//        tagLab.layer.cornerRadius = 8
//        tagLab.layer.backgroundColor = UIColor.red.cgColor
        tagLab.layer.addCornerRadius(radius: 8, maskColor: UIColor.lightGray)

//        let bgImg = UIImage(named: "color")
//        rightBtn.setBackgroundImage(bgImg?.image(radius: 16), for: .normal)
//        rightBtn.backgroundColor = UIColor.green

//        rightBtn.layer.cornerRadius = 8
//        rightBtn.layer.masksToBounds = true
    }

    override func layoutSubviews() {
//        print("\(self) : LayoutSubviews")
    }
}
