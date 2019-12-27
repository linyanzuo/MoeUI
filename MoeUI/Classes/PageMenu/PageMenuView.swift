//
//  PageMenuView.swift
//  MoeUI
//
//  Created by Zed on 2019/8/3.
//

import UIKit

class PageMenuView: UIScrollView {
    // MARK: Object Life Cycle
    var configuration = PageMenuConfiguration()

    init(frame: CGRect = .zero, configuration: PageMenuConfiguration) {
        self.configuration = configuration
        super.init(frame: frame)
        setupSelf()
        setupConstant()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("请调用`init(configuration: PageMenuConfiguration)`方法替代")
    }
    
    private func setupSelf() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }

    private func setupConstant() {
        if configuration.addBottomMenuHairline == true {
//            bottomSeparationLine.translatesAutoresizingMaskIntoConstraints = false
//            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bottomSeparationLine]|",
//                                                          options: NSLayoutConstraint.FormatOptions(rawValue: 0),
//                                                          metrics: nil,
//                                                          views: ["bottomSeparationLine" : bottomSeparationLine]))
//            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(configuration.menuHeight)-[bottomSeparationLine(0.5)]",
//                                                          options: NSLayoutConstraint.FormatOptions(rawValue: 0),
//                                                          metrics: nil,
//                                                          views: ["bottomSeparationLine" : bottomSeparationLine]))
        }
    }

    // MARK: Getter & Setter
    private(set) lazy var bottomSeparationLine: UIView = {
        let line = UIView(frame: .zero)
        line.backgroundColor = configuration.bottomMenuHairlineColor
        addSubview(line)

//        line.layer.masksToBounds = false
//        line.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
//        line.layer.shadowColor = configuration.bottomMenuHairlineColor.cgColor
//        line.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        line.layer.shadowOpacity = 0.5

        return line
    }()
}
