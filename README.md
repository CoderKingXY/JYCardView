# JYCardView
Using UICollectionView to implement the card stack layout.

使用UICollectionView实现的轻量级卡牌堆叠式布局。

![image](https://github.com/Lucky-JY/JYCardView/blob/main/JYCardView.gif)

## 使用方式

```swift
import UIKit

class ViewController: UIViewController {

    private var dataSource = createDataSource()
    
    private var cardView: JYCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        cardView = JYCardView(frame: CGRect(origin: .zero, size: CGSize(width: 280, height: 380)))
        cardView.center = CGPoint(x: view.bounds.width * 0.5, y: view.bounds.height * 0.5)
        cardView.register(cellClass: CardViewCell.self, forCellWithReuseIdentifier: CardViewCell.cellID)
        cardView.cardViewDataSource = self
        cardView.backgroundColor = view.backgroundColor
        view.addSubview(cardView)
    }
    
    static func createDataSource() -> [CardViewModel] {
        return [
            CardViewModel(imageURLString: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSlV31scIL9wgD5QF390sm8LZ7o-C6ZGfdUPA&usqp=CAU", title: "彭于晏"),
            CardViewModel(imageURLString: "https://imgs.jushuo.com/album/2018-09-27/5bac2fa689055.com/large/pgc-image/1537954274800026ad2a9c8", title: "张馨予"),
            CardViewModel(imageURLString: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQq0BYYn6kuYmDMK46tMtTGEYeXDMb74K2kdQ&usqp=CAU", title: "柳岩"),
            CardViewModel(imageURLString: "https://p1.meituan.net/movie/bfdf65acdf8cca2e4a832888a6da594d157051.jpg@750w_680h_1e_1c", title: "刘德华"),
            CardViewModel(imageURLString: "https://5b0988e595225.cdn.sohucs.com/images/20191031/f6b1282ab0fb407689461b8875557db0.jpeg", title: "吴彦祖"),
            CardViewModel(imageURLString: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS5BjeIcnfYJn-Y4KnzR1of-w0hGZx3D2BdWg&usqp=CAU", title: "吴京")
        ]
    }
}

extension ViewController: JYCardViewDataSource {
    func numberOfItems(in cardView: JYCardView) -> Int {
        dataSource.count
    }
    
    func cardView(cardView: JYCardView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = cardView.dequeueReusableCell(withReuseIdentifier: CardViewCell.cellID, forIndex: index) as! CardViewCell
        cell.cardViewModel = dataSource[index]
        return cell
    }
    
    func cardView(cardView: JYCardView, didRemoveCell cell: UICollectionViewCell, updateCallback:((Bool)->Void)?) {
        dataSource.removeFirst()
        
        cardView.performBatchUpdates(updates: {
            cardView.collectionView.deleteItems(at: [IndexPath(item: 0, section: 0)])
        }, completion: {
            if self.dataSource.count < 2 { // 加载更多数据
                
                let newModels = ViewController.createDataSource()
                let indexes: [IndexPath] = newModels.indices.map {
                    IndexPath(item: $0+self.dataSource.count, section: 0)
                }
                
                self.dataSource.append(contentsOf: newModels)
                cardView.insertCells(atIndexPath: indexes)
            }
            updateCallback?($0)
        })
    }
}
```
