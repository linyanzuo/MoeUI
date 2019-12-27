//
//  Unity.swift
//  MoeUI
//
//  Created by Zed on 2019/9/3.
//


/// Programming unity standard
public protocol Unity {}


/// UIView programming unity standard
public protocol ViewUnity: Unity where Self: UIView  {
    func setupSelf()
    func setupSubviews()
    func setupConstraints()
}


/// UIViewController programming unity standard
public protocol ViewControllerUnity: Unity where Self: UIViewController  {
    func setupNavigation()
    func setupViews()
    func setupViewConstraints()
    func setupRequest()
}
public extension ViewControllerUnity {
    func setupNavigation() {}
    func setupViews() {}
    func setupViewConstraints() {}
    func setupRequest() {}
}
