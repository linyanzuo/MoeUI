//
//  PageMenuController.swift
//  PageMenu
//
//  Created by Zed on 2019/5/20.
//

import UIKit


@objc public protocol MoePageMenuControllerDelegate {
    @objc optional func willMoveToPage(_ controller: UIViewController, index: Int)
    @objc optional func didMoveToPage(_ controller: UIViewController, index: Int)
}


open class MoePageMenuController: UIViewController {
    // MARK: Object Life Cycle
    /// 样式配置参数
    var configuration = PageMenuConfiguration()

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(pageViewControllers: [UIViewController], frame: CGRect, pageMenuOption: [PageMenuOption]?) {
        super.init(nibName: nil, bundle: nil)

        controllerArray = pageViewControllers;
        self.view.frame = frame

        if let options = pageMenuOption {
            configurePageMenu(options: options)
        }

        setupSubview()
        if menuView.subviews.count == 0 {
            configureUserInterface()
        }
    }

    // MARK: Subviews

    // MARK: -- 顶部列表栏

    /// 菜单滚动视图
//    let menuView = UIScrollView()
    internal lazy var menuView: PageMenuView = {
        let menuView = PageMenuView(configuration: configuration)
        return menuView
    }()
    var startingMenuMargin : CGFloat = 0.0

    var menuItems : [PageMenuItem] = []
    var menuItemWidths : [CGFloat] = []
    var menuItemMargin : CGFloat = 0.0
    var totalMenuItemWidthIfDifferentWidths : CGFloat = 0.0

    // MARK: -- 内容页面栏
    let controllerView = UIScrollView()
    var controllerArray : [UIViewController] = []
    /// 记录滚动时的页面索引, key与value为索引值
    var pagesAddedDictionary : [Int : Int] = [:]

    /// 选中项的指示器
    var selectionIndicatorView : UIView = UIView()
    public var currentPageIndex : Int = 0
    /// 记录换页操作前的展示页索引
    var lastPageIndex : Int = 0

    // MARK: Screen Oreitation Handling
    enum PageMenuScrollDirection : Int {
        case left
        case right
        case other
    }

    var lastScrollDirection : PageMenuScrollDirection = .other
    var currentOrientationIsPortrait : Bool = true
    var pageIndexForOrientationChange : Int = 0
    var didLayoutSubviewsAfterRotation : Bool = false

    // MARK: Event Handling
    // MARK: -- 拖拽计算
    var didScrollAlready : Bool = false
    var lastControllerScrollViewContentOffset : CGFloat = 0.0
    var startingPageForScroll : Int = 0

    // MARK: -- 点击事件处理
    open weak var delegate : MoePageMenuControllerDelegate?
    /** 是否点击`MenuItem`所触发的`ContrllerView`滚动 */
    var isTapMenuItemToScroll : Bool = false
    var tapTimer : Timer?
}

