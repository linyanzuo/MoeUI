//
//  MaskView.swift
//  MoeUI
//
//  Created by Zed on 2019/7/31.
//
//  遮罩视图

import UIKit


class MaskView: UIView {
    // MARK: Object Life Cycle
    static let shared = MaskView()
    private init() {
        super.init(frame: .zero)
        setupSelf()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var subviewsOfToVCRootView: Array<UIView>?

    private func setupSelf() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panAction(_:))))

        self.backgroundColor = UIColor.black
        self.alpha = 0.0
    }

    // MARK: Event Response
    @objc func tapAction(_ sender: UIButton) {

    }

    @objc func panAction(_ sender: UIButton) {

    }

    // MARK: UIResponder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { }
}
