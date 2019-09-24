//
//  SettingCell.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/9/20.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeUI
import SnapKit


protocol SettingData {}
struct TitleSetting: SettingData {
    var title: String
    var isArrowShow: Bool
}
struct DetailSetting: SettingData {
    var title: String
    var detail: String
}
struct SwitchSetting: SettingData {
    var title: String
    var isOn: Bool
}
struct ImageSetting: SettingData {
    enum ImagePosition {
        case left
        case right
    }

    var title: String
    var image: UIImage
    var position: ImagePosition
}


extension AppearanceIdentifier {
    static let settingTitle = AppearanceRegister.generateIdentifier()
    static let settingDetail = AppearanceRegister.generateIdentifier()
    static let settingArrowImg = AppearanceRegister.generateIdentifier()
    static let settingSeparator = AppearanceRegister.generateIdentifier()
}


class SettingCell: UnitedTableViewCell {
    // MARK: Public Methods
    func setData(_ data: SettingData) {
        if data is TitleSetting, let setting = data as? TitleSetting {
            setTitle(setting)
        } else if data is DetailSetting, let setting = data as? DetailSetting {
            setDetail(setting)
        } else if data is SwitchSetting, let setting = data as? SwitchSetting {
            setSwitch(setting)
        } else if data is ImageSetting, let setting = data as? ImageSetting {
            setImage(setting)
        }
    }

    func setSeparator(isShow: Bool, inset: UIEdgeInsets) {
        separator.isHidden = !isShow
        guard isShow == true else { return }
        separator.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(inset.left)
            maker.right.equalToSuperview().offset(-inset.right)
            maker.bottom.equalToSuperview()
            maker.height.equalTo(1)
        }
    }

    // MARK: Data & Constraints
    private func setTitle(_ data: TitleSetting) {
        titleLabel.text = data.title
        let exceptViews = data.isArrowShow == true ? [titleLabel, arrowImgView] : [titleLabel]
        hiddenSubview(except: exceptViews)

        titleLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(16.0)
            maker.top.equalToSuperview().offset(16.0)
            maker.bottom.equalToSuperview().offset(-16.0)
        }
        guard data.isArrowShow == true else { return }
        arrowImgView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(titleLabel)
            maker.right.equalToSuperview().offset(-16)
        }
    }

    private func setDetail(_ data: DetailSetting) {
        titleLabel.text = data.title
        detailLabel.text = data.detail
        hiddenSubview(except: [titleLabel, detailLabel, arrowImgView])

        titleLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(16.0)
            maker.top.equalToSuperview().offset(16.0)
            maker.bottom.equalToSuperview().offset(-16.0)
        }
        arrowImgView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(titleLabel)
            maker.right.equalToSuperview().offset(-16)
        }
        detailLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(arrowImgView)
            maker.right.equalTo(arrowImgView.snp.left).offset(-10)
        }
    }

    private func setSwitch(_ data: SwitchSetting) {
        titleLabel.text = data.title
        switchView.setOn(data.isOn, animated: true)
        hiddenSubview(except: [titleLabel, switchView])

        titleLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(16.0)
            maker.top.equalToSuperview().offset(16.0)
            maker.bottom.equalToSuperview().offset(-16.0)
        }
        switchView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(titleLabel)
            maker.right.equalToSuperview().offset(-16)
        }
    }

    private func setImage(_ data: ImageSetting) {
        titleLabel.text = data.title
        let imageWidth: CGFloat = data.position == .left ? 28 : 32
        iconImgView.updateAppearance { (appear) in
            appear.image(data.image).cornerRadius(imageWidth / 2)
        }
        hiddenSubview(except: [titleLabel, iconImgView])

        if data.position == .right {
            titleLabel.snp.makeConstraints { (maker) in
                maker.centerY.equalToSuperview()
                maker.top.equalToSuperview().offset(16.0)
                maker.bottom.equalToSuperview().offset(-16.0)
                maker.left.equalToSuperview().offset(16.0)
            }
            iconImgView.snp.makeConstraints { (maker) in
                maker.centerY.equalTo(titleLabel)
                maker.right.equalToSuperview().offset(-16.0)
                maker.width.height.equalTo(32.0)
            }
        } else if data.position == .left {
            iconImgView.snp.makeConstraints { (maker) in
                maker.left.equalToSuperview().offset(16.0)
                maker.centerY.equalTo(titleLabel)
                maker.width.height.equalTo(imageWidth)
            }
            titleLabel.snp.makeConstraints { (maker) in
                maker.left.equalTo(iconImgView.snp.right).offset(10.0)
                maker.centerY.equalToSuperview()
                maker.top.equalToSuperview().offset(16.0)
                maker.bottom.equalToSuperview().offset(-16.0)
            }
        }
    }

    private func hiddenSubview(except: [UIView]) {
        for subview in self.contentView.subviews {
            var isCurrentExcept = false
            for exceptView in except {
                if subview == exceptView {
                    isCurrentExcept = true
                    break
                }
            }
            if isCurrentExcept == true { subview.snp.removeConstraints() }
            else { subview.isHidden = true }
        }
    }

    // MARK: Open Method
//    open func settingTitleAppearance() -> Appearance {
//
//    }

    // MARK: Override methods
    override func setupSelf() {
        super.setupSelf()
        self.selectionStyle = .none
    }

    // MARK: Getter & Setter
    private(set) lazy var titleLabel: MoeLabel = {
        if AppearanceRegister.shared.isRegistered(identifier: .settingTitle) == false {
            MoeUI.register(identifier: .settingTitle) { (appear) in
                appear.text(nil).color(UIColor(rgb: 0x333333)).font(15, weight: .medium)
            }
        }
        return MoeUI.makeLabel(toView: self.contentView, with: .settingTitle)!
    }()

    private(set) lazy var detailLabel: MoeLabel = {
        if AppearanceRegister.shared.isRegistered(identifier: .settingDetail) == false {
            MoeUI.register(identifier: .settingDetail) { (appear) in
                appear.text(nil).color(UIColor(rgb: 0x999999)).font(14, weight: .regular)
            }
        }
        return MoeUI.makeLabel(toView: self.contentView, with: .settingDetail)!
    }()

    private(set) lazy var iconImgView: MoeImageView = {
        return MoeUI.makeImageView(toView: self.contentView, nil)
    }()

    private(set) lazy var arrowImgView: MoeImageView = {
        if AppearanceRegister.shared.isRegistered(identifier: .settingArrowImg) == false {
            MoeUI.register(identifier: .settingArrowImg) { (appear) in
                appear.image(UIImage(named: "arrow_right")!)
            }
        }
        return MoeUI.makeImageView(toView: self.contentView, with: .settingArrowImg)!
    }()

    private(set) lazy var switchView: UISwitch = {
        let switchView = UISwitch(frame: .zero)
        self.contentView.addSubview(switchView)
        return switchView
    }()

    private(set) lazy var separator: MoeView = {
        if AppearanceRegister.shared.isRegistered(identifier: .settingSeparator) == false {
            MoeUI.register(identifier: .settingSeparator) { (appear) in
                appear.background(color: UIColor(rgb: 0xf0f0f0))
            }
        }
        return MoeUI.makeView(toView: self.contentView, with: .settingSeparator)!
    }()
}
