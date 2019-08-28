//
//  MenuItem.swift
//  PageMenu
//
//  Created by Zed on 2019/5/16.
//
//  顶部菜单的列表项

import UIKit


struct PageMenuItemOption {
    var width: CGFloat = 0.0
    var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var textColor: UIColor = UIColor(rgb: 0x333333)

    var scrollViewHeight: CGFloat = 0.0
    var indicatorHeight: CGFloat = 0.0

    var separatorPercentageHeight: CGFloat = 0.0
    var separatorWidth: CGFloat = 0.0
    var separatorRoundEdges: Bool = true
    var separatorColor: UIColor = UIColor(rgb: 0x999999)
}


class PageMenuItem: UIView {
    // MARK: Object Life Cycle
    private let option: PageMenuItemOption
    init(frame: CGRect = .zero, option: PageMenuItemOption) {
        self.option = option
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("请调用`init(option: PageMenuItemOption)`方法替代")
    }

    // MARK: Public Method
    var menuItemSeparator : UIView?

    /// 加载子视图
    func setupMenuItem(option: PageMenuItemOption) {
        titleLabel.frame = CGRect(x: 0.0, y: 0.0,
                                  width: option.width,
                                  height: option.scrollViewHeight - option.indicatorHeight)
        titleLabel.font = option.font
        titleLabel.textColor = option.textColor

        // menuItemSeparator的加载
        menuItemSeparator = UIView(frame: CGRect(x: option.width - (option.separatorWidth / 2),
                                                 y: floor(option.scrollViewHeight * ((1.0 - option.separatorPercentageHeight) / 2.0)),
                                                 width: option.separatorWidth,
                                                 height: floor(option.separatorWidth * option.separatorPercentageHeight)))
        menuItemSeparator!.backgroundColor = option.separatorColor
        menuItemSeparator!.isHidden = true

        if option.separatorRoundEdges {
            menuItemSeparator!.layer.cornerRadius = menuItemSeparator!.frame.width / 2
        }
        self.addSubview(menuItemSeparator!)
    }

    /// 实例化item后, 调用该方法来完成item的初始化
    func configure(for pageMenuController: MoePageMenuController, controller: UIViewController, index: CGFloat) {
        let configuration = pageMenuController.configuration
        // (宽度适配标题模式, 每次计算后都将itemWidth更新至configuration.width, 之后创建了menuItem并执行了congirue方法)
        var menuItemWidth: CGFloat = configuration.menuItemWidth

        // Segment样式时不使用configuration, 需要单独计算itemWidth
        if pageMenuController.configuration.useMenuLikeSegmentedControl {
            if pageMenuController.menuItemMargin > 0 {
                let marginSum = pageMenuController.menuItemMargin * CGFloat(pageMenuController.controllerArray.count + 1)
                menuItemWidth = (pageMenuController.view.frame.width - marginSum) / CGFloat(pageMenuController.controllerArray.count)
            } else {
                menuItemWidth = CGFloat(pageMenuController.view.frame.width) / CGFloat(pageMenuController.controllerArray.count)
            }

            // Segment样式时, menuItem间需要显示分割符
            if Int(index) < pageMenuController.controllerArray.count - 1 {
                self.menuItemSeparator?.isHidden = false
            }
        }

        let option = PageMenuItemOption(width: menuItemWidth,
                                        font: configuration.menuItemFont,
                                        textColor: configuration.unselectedMenuItemLabelColor,
                                        scrollViewHeight: configuration.menuHeight,
                                        indicatorHeight: configuration.selectionIndicatorHeight,
                                        separatorPercentageHeight: configuration.menuItemSeparatorPercentageHeight,
                                        separatorWidth: configuration.menuItemSeparatorWidth,
                                        separatorRoundEdges: configuration.menuItemSeparatorRoundEdges,
                                        separatorColor: configuration.menuItemSeparatorColor)
        setupMenuItem(option: option)

        self.titleLabel.adjustsFontSizeToFitWidth = configuration.titleTextSizeBasedOnMenuItemWidth
        self.titleLabel.text = controller.title ?? "Menu \(Int(index) + 1)"
    }

    /// 设置item标题
    func setTitle(_ text: String) {
        titleLabel.text = text
        titleLabel.sizeToFit()
    }

    // MARK: Getter & Setter
    private(set) lazy var titleLabel: UILabel = {
        let frame = CGRect(x: 0.0, y: 0.0,
                           width: option.width,
                           height: option.scrollViewHeight - option.indicatorHeight)
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.textAlignment = .center
        self.addSubview(label)

        return label
    }()
}

