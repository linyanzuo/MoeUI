//
//  TextBlurViewController.swift
//  MoeUI_Example
//
//  Created by Zed on 2021/1/19.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


class TextBlurViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(200)
            make.height.equalTo(18)
        }
        detailLabel.text = "文本内容高斯模糊"
        detailLabel.sizeToFit()
        
        view.addSubview(bluredLabel)
        bluredLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(detailLabel.snp.bottom).offset(100)
        }
        bluredLabel.text = "文本内容高斯模糊"
        bluredLabel.sizeToFit()
        bluredLabel.gaussianBlur(radius: 8)
        
        view.addSubview(blurIV)
        blurIV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(bluredLabel.snp.bottom).offset(100)
        }
        UIGraphicsBeginImageContextWithOptions(blurIV.bounds.size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            detailLabel.layer.render(in: context)
            let textImage = UIGraphicsGetImageFromCurrentImageContext()
            blurIV.image = textImage
        }
        UIGraphicsEndImageContext()
        
        detailLabel.gaussianBlur(radius: 10)
    }
    
    private(set) lazy var detailLabel: UILabel = {
//        let l = UILabel(frame: CGRect(x: 50, y: 100, width: 256, height: 44))
        let l = UILabel(frame: .zero)
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        l.backgroundColor = .orange
        return l
    }()
    
    private(set) lazy var bluredLabel: UILabel = {
//        let l = UILabel(frame: CGRect(x: 50, y: 250, width: 256, height: 44))
        let l = UILabel(frame: .zero)
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        l.backgroundColor = .green
        return l
    }()
    
    lazy var blurIV: UIImageView = {
//        let iv = UIImageView(frame: CGRect(x: 50, y: 400, width: 256, height: 44))
        let iv = UIImageView(frame: .zero)
        iv.contentMode = .topLeft
        return iv
    }()
}
