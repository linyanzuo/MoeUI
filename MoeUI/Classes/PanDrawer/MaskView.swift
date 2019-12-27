//
//  MaskView.swift
//  MoeUI
//
//  Created by Zed on 2019/7/31.
//
//  遮罩视图

import UIKit


public extension NSNotification.Name {
    static let SidePanDrawerDidTapMaskView = Notification.Name("SidePanDrawerDidTapMaskView")
    static let SidePanDrawerDidPanMaskView = Notification.Name("SidePanDrawerDidPanMaskView")
}


class MaskView: UIView {
    // MARK: Object Life Cycle
//    var subviewsOfToVCRootView: Array<UIView>?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private init() {
        super.init(frame: .zero)
        setupSelf()
    }

    private struct Static {
        static var instance: MaskView?
    }
    class var shared: MaskView {
        if Static.instance == nil { Static.instance = MaskView() }
        return Static.instance!
    }

    func releaseShared() {
        MaskView.Static.instance?.removeFromSuperview()
        MaskView.Static.instance = nil
    }

//    deinit {
//        MLog("MaskView deinit")
//    }

    private func setupSelf() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panAction(_:))))

        self.backgroundColor = UIColor.black
        self.alpha = 0.0
    }

    // MARK: Event Response
    @objc func tapAction(_ gesture: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .SidePanDrawerDidTapMaskView, object: self)
    }

    @objc func panAction(_ gesture: UIPanGestureRecognizer) {
        NotificationCenter.default.post(name: .SidePanDrawerDidPanMaskView, object: gesture)
    }

    // MARK: UIResponder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { }
}
