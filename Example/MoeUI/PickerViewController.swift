//
//  PickerViewController.swift
//  MoeUI
//
//  Created by Zed on 2019/8/17.
//

import UIKit
import MoeUI
import MoeCommon


@available(iOS 9.0, *)
protocol PSPickerViewControllerDelegate {
    func pickerViewController(pickerVC: PickerViewController, didSelectItemAt index: Int)
}


@available(iOS 9.0, *)
class PickerViewController: UIViewController, MaskAlertAnimatorProtocol, UIPickerViewDelegate, UIPickerViewDataSource, UIViewControllerTransitioningDelegate {
    private(set) var pickerTitle: String
    private(set) var itemTitles: [String]

    private var selectedIndex: Int = 0

    var delegate: PSPickerViewControllerDelegate?

    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(title: String) instead")
    }

    init(title: String, itemTitles: [String]) {
        self.pickerTitle = title
        self.itemTitles = itemTitles
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        setupSubview()
    }

    func setupSubview() {
        maskBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: maskBtn, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ])
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0)
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -16.0),
            NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 49.0)
        ])
        picker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            NSLayoutConstraint(item: picker, attribute: .top, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: picker, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: picker, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: picker, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ])
    }

    // MARK: UIPickerViewDelegate & UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemTitles.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let title = itemTitles[row]
        let label = Designator.makeLabel { (appear) in
            appear.background(UIColor.clear)
            appear.text(title).color(0xEAEAED).font(18, weight: .medium)
        }
        label.textAlignment = .center
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        MLog(row)
        self.selectedIndex = row
    }

    // MARK: UIViewControllerTransitioningDelegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MaskAlertAnimator(owner: self, transitionType: .present)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MaskAlertAnimator(owner: self, transitionType: .dismiss)
    }

    // MARK: Event Response
    @objc func maskBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func submitBtnAction(_ sender: UIButton) {
        let index = self.selectedIndex
        self.delegate?.pickerViewController(pickerVC: self, didSelectItemAt: index)
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Getter & Setter
    private(set) lazy var maskBtn: UIButton = {
        let maskBtn = Designator.makeButton(toView: self.view) { (appear) in
            appear.background(.black)
        }
        maskBtn.alpha = 0.6
        maskBtn.addTarget(self, action: #selector(maskBtnAction(_:)), for: .touchUpInside)
        return maskBtn
    }()

    private(set) lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(rgb: 0x1F1F48)
        self.view.addSubview(view)

        return view
    }()

    @available(iOS 9.0, *)
    private lazy var stackView: UIStackView = {
        let cancelBtn = Designator.makeButton { (des) in
            des.text("取消").color(0xEAEAED).font(15, weight: .bold)
        }
        let submitBtn = Designator.makeButton { (appear) in
            appear.text("完成").color(0xEAEAED).font(15, weight: .bold)
        }
        let titleLabel = Designator.makeLabel { (appear) in
            appear.text(self.pickerTitle).color(0xEAEAED).font(15, weight: .bold)
        }

        cancelBtn.addTarget(self, action: #selector(cancelBtnAction(_:)), for: .touchUpInside)
        submitBtn.addTarget(self, action: #selector(submitBtnAction(_:)), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [cancelBtn, titleLabel, submitBtn])
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        self.contentView.addSubview(stackView)

        return stackView
    }()

    private lazy var picker: UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        picker.delegate = self
        picker.backgroundColor = UIColor(rgb: 0x1F1F48)
        self.contentView.addSubview(picker)

        return picker
    }()

    // MARK: SheetAnimatorProtocol
    func maskViewForAnimation() -> UIView {
        return maskBtn
    }

    func contentViewForAnimation() -> UIView {
        return contentView
    }
}


extension Alerter {
    class func sheet() {
        if #available(iOS 9.0, *) {
            let topVC = UIApplication.moe.topViewController()

            let pickerVC = PickerViewController(title: "请选择", itemTitles: ["iOS", "JavaEE", "Android", "Web"])
            pickerVC.view.backgroundColor = .clear
            pickerVC.modalPresentationStyle = .overCurrentContext
            pickerVC.transitioningDelegate = pickerVC

            topVC?.present(pickerVC, animated: true, completion: nil)
            MLog(topVC)
        }
    }
}
