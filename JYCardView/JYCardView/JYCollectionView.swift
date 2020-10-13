//
//  JYCollectionView.swift
//  JYCardView
//
//  Created by 王笑宇 on 2020/10/13.
//

import UIKit

class JYCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        if subview is UICollectionViewCell {
            sendSubviewToBack(subview)
        }
    }
}
