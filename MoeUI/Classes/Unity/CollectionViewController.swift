//
//  CollectionViewController.swift
//  MoeUI
//
//  Created by Zed on 2020/12/22.
//

import UIKit
import MoeCommon


/// 集合视图控制器基类
open class CollectionViewController: ViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private var layout: UICollectionViewLayout
    
    public init(flowLayoutDirection: UICollectionView.ScrollDirection) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = flowLayoutDirection
        self.layout = layout
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(layout: UICollectionViewLayout) {
        self.layout = layout
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("「CollectionViewController」的子类必须重写「collectionView(_, cellForItemAt)」方法，不需要执行「super」")
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
    
    open private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        return collectionView
    }()
}

