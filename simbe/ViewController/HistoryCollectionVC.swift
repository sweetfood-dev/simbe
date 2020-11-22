//
//  HistoryCollectionVC.swift
//  simbe
//
//  Created by 권지수 on 2020/11/21.
//

import UIKit
import CoreData

class HistoryCollectionVC: UIViewController {

    private let reuseIdentifier = "HistoryCollectionCell"
    private let context = AppDelegate.context
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView.collectionViewLayout as? PinterestTypeLayout {
            layout.delegate = self
        }
    }
}

// MARK: - CollectionLayoutDelegate
extension HistoryCollectionVC: PinterestTypeLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeIndexPath: IndexPath) -> CGFloat {
        var returnSize: CGFloat = 50
        returnSize = 50
//        let categories = getCategorySortedPercent()
//        if  categories.count > 0 {
//            let percent = categories[sizeIndexPath.row].percentage
//            returnSize = CGFloat(percent * Double(2)) * collectionViewContentHeight
//        }
        return returnSize
    }
}

extension HistoryCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("kjsDebug numberOfItemsInSection")
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("kjsDebug cellForItemAt")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HistoryCollectionViewCell
        cell.categoryLabel.text = "test"
        cell.percentLabel.text = "test"
        cell.backgroundColor = getRandomColor()
        return cell
    }
    
    
}

// MARK: - CoreData
extension HistoryCollectionVC {
    private func getCategoryList(context: NSManagedObjectContext) -> [PayCategory]? {
        let categoryList = PayCategory.getItemList(context: context)
        
        return categoryList
    }
}

// MARK: - Util
extension HistoryCollectionVC {
    private func getRandomColor()->UIColor{
        
        let red = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let green = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let blue = CGFloat(arc4random()) / CGFloat(UInt32.max)
        
        return UIColor.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
