////
////  ViewController.swift
////  MoePageMenuDemo
////
////  Created by Zed on 2019/5/16.
////

import UIKit
import MoeUI

//class PageDemoViewController: UIViewController, PageMenuControllerDelegate {
//
//    let dataSources: [String] = ["一", "两个", "三个字", "四个文字", "共五个文本", "六个文本内容"]
//    var pageMenu: MoePageMenuController?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.title = "PAGE MENU"
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//
//        // 创建控制器实例, 并添加到数组中
//        var controllerArray: [UIViewController] = []
//
//        for i in 0...dataSources.count - 1 {
//            let controller = ContactViewController(style: .plain)
//            controller.parentNavigationController = self.navigationController
//            controller.title = dataSources[i]
//            controllerArray.append(controller)
//        }
//
//        let parameter: [PageMenuOption] = [
//            .menuHeight(49),
//            .menuItemSeparatorWidth(4.3),
//            .scrollMenuBackgroundColor(UIColor.white),
//            .bottomMenuHairlineColor(UIColor.green),
//            .selectionIndicatorColor(UIColor.red),
//            .menuMargin(44.0),
//            .menuItemWidth(64.0),
//            .selectedMenuItemLabelColor(UIColor.purple),
//            .unselectedMenuItemLabelColor(UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)),
//            .menuItemFont(UIFont.systemFont(ofSize: 14)),
//            .menuItemSeparatorRoundEdges(true),
//            .selectionIndicatorHeight(2.0),
//            .menuItemSeparatorPercentageHeight(0.1),
////            .useMenuLikeSegmentedControl(true),
//            .centerMenuItems(true)
////            .menuItemWidthBasedOnTitleTextWidth(true),
//        ]
//
//        pageMenu = MoePageMenuController(pageViewControllers: controllerArray,
//                                         frame: CGRect(x: 0.0, y: 88.0, width: view.frame.width, height: view.frame.height),
//                                         pageMenuOption: parameter)
//        pageMenu!.delegate = self
//        view.addSubview(pageMenu!.view)
//    }
//
//    func willMoveToPage(_ controller: UIViewController, index: Int) {
//        print("will move to page")
//    }
//
//    func didMoveToPage(_ controller: UIViewController, index: Int) {
//        print("did move to page")
//    }
//
//}
//
//
//
