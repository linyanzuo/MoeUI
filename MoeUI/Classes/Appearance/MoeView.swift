//
//  MoeView.swift
//  MoeUI
//
//  Created by Zed on 2019/8/28.
//

import UIKit


open class MoeView: UIView, AppearanceUnity, AppearanceApply {
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientIfLayoutSubviews()
        updateShadowIfLayoutSubviews()
    }
}


extension MoeUI {
    public class func makeView(toView: UIView? = nil, _ closure: AppearanceClosure?) -> MoeView {
        let view = MoeView(frame: .zero)
        toView?.addSubview(view)
        if closure != nil {
            closure!(view.appearance)
            view.applyAttribute()
        }
        return view
    }

    public class func makeView(toView: UIView? = nil, with appearance: Appearance) -> MoeView {
        let view = MoeView(appearance: appearance)
        toView?.addSubview(view)
        return view
    }

    public class func makeView(toView: UIView? = nil, with identifier: AppearanceIdentifier) -> MoeView? {
        let appearance = AppearanceRegister.shared.dequeue(with: identifier)
        guard appearance != nil else { return nil }

        let view = MoeView(appearance: appearance!)
        if toView != nil { toView?.addSubview(view) }
        return view
    }
}
