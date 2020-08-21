//
//  ViewController.swift
//  MoeUI
//
//  Created by linyanzuo1222@gmail.com on 07/23/2019.
//  Copyright (c) 2019 linyanzuo1222@gmail.com. All rights reserved.
//

import UIKit
import MoeCommon
import MoeUI

class CornerRadiusVC: UIViewController {
    @IBOutlet weak var onePieceImgView: UIImageView!
    @IBOutlet weak var clearView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray

//        let image = UIImage.moe.roundedImage(radius: 60,
//                                             corner: .allCorners,
//                                             size: CGSize(width: 160, height: 160),
//                                             borderWidth: 0,
//                                             borderColor: UIColor.white,
//                                             backgroundColor: UIColor.white)
        let image = UIImage.moe.roundedMaskImage(radius: 60,
                                             size: CGSize(width: 160, height: 160),
                                             maskColor: UIColor.white,
                                             borderWidth: 5,
                                             borderColor: UIColor.red)
        onePieceImgView.image = image

        onePieceImgView.backgroundColor = UIColor.white
        onePieceImgView.layer.addCornerRadius(radius: 60)

        clearView.backgroundColor = UIColor.white
        clearView.layer.addCornerRadius(radius: 32, maskColor: UIColor.green)
//        clearView.layer.addCornerRadius(radius: 32, corner: UIRectCorner(arrayLiteral: [.topLeft, .topRight]), borderWidth: 0, maskColor: UIColor.green)

    }
}
