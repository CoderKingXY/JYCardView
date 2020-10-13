//
//  JYCardView.swift
//  JYCardView
//
//  Created by 王笑宇 on 2020/10/13.
//

import UIKit

protocol JYCardViewDataSource: NSObject {
    func numberOfItems(in cardView: JYCardView) -> Int
    func cardView(cardView: JYCardView, cellForItemAt index: Int) -> UICollectionViewCell
    /// 移除cell之后, 调用此方法, 需要从数据源移除model. 数据处理完成之后,必须在最后调用callback闭包
    func cardView(cardView: JYCardView, didRemoveCell cell: UICollectionViewCell, updateCallback:((Bool)->Void)?)
}

/// 主控件
class JYCardView: UIView {
    
    var collectionView: JYCollectionView!
    var movingPoint: CGPoint = .zero
    weak var cardViewDataSource: JYCardViewDataSource!
    
    override var backgroundColor: UIColor? {
        didSet {
            collectionView.backgroundColor = backgroundColor
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
    }
    
    func setupSubview() {
        let layout = JYCardViewLayout()
        collectionView = JYCollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.clipsToBounds = false
        collectionView.dataSource = self
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(panGesture:)))
        collectionView.addGestureRecognizer(panGesture)
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
}

/// Public
extension JYCardView {
    func register(cellClass: AnyClass?, forCellWithReuseIdentifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    
    func dequeueReusableCell(withReuseIdentifier: String, forIndex: Int) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: withReuseIdentifier, for: IndexPath(item: forIndex, section: 0))
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func insertCells(atIndexPath: [IndexPath]) {
        UIView.performWithoutAnimation {
            collectionView.insertItems(at: atIndexPath)
        }
    }
    
    func performBatchUpdates(updates: (()->Void)?, completion: ((Bool)->Void)?) {
        collectionView.performBatchUpdates(updates, completion: completion)
    }
}

extension JYCardView {
   
    @objc func panGestureAction(panGesture: UIPanGestureRecognizer) {
        // 获取到当前cell
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) else { return }
        
        switch panGesture.state {
        case .began:
            movingPoint = .zero
        case .changed:
            let movePoint = panGesture.translation(in: panGesture.view)
            movingPoint = CGPoint(x: movingPoint.x + movePoint.x, y: movingPoint.y + movePoint.y)
            
            cell.transform = CGAffineTransform(translationX: movingPoint.x, y: movingPoint.y)
            
            panGesture.setTranslation(.zero, in: panGesture.view)
        case .ended:
            
            if movingPoint.x > 100 {
                UIView.animate(withDuration: 0.25) {
                    let currentTransform = cell.transform
                    cell.transform = currentTransform.translatedBy(x: 200, y: 200)
                    
                } completion: { _ in
                
                    cell.isHidden = true
                    self.cardViewDataSource.cardView(cardView: self, didRemoveCell: cell, updateCallback:{ _ in
                        cell.isHidden = false
                    })
                }
                
            } else if movingPoint.x < -100 {
                UIView.animate(withDuration: 0.25) {
                    let currentTransform = cell.transform
                    cell.transform = currentTransform.translatedBy(x: -200, y: 200)
                    
                } completion: { _ in
                
                    cell.isHidden = true
                    self.cardViewDataSource.cardView(cardView: self, didRemoveCell: cell, updateCallback:{ _ in
                        cell.isHidden = false
                    })
                }
            } else {
                UIView.animate(withDuration: 0.25) {
                    cell.transform = .identity
                }
            }
            
        default:
            print(movingPoint)
        }
    }
    
}

extension JYCardView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cardViewDataSource.numberOfItems(in: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cardViewDataSource.cardView(cardView: self, cellForItemAt: indexPath.item)
    }
}

