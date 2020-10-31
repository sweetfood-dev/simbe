//
//  MainCollectionVC.swift
//  simbe
//
//  Created by 권지수 on 2020/10/30.
//

import UIKit

private let reuseIdentifier = "MainCollectionCell"

class MainCollectionVC: UICollectionViewController {
    
//    private var dataManage: DataMO! = DataMO()
    private let dataManage = DataMO.shared
    
    override func viewDidLoad() {
        
        if let layout = collectionView?.collectionViewLayout as? PinterestTypeLayout {
            layout.delegate = self
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    func uiInit(){
    }
    
    
    @IBAction func add(_ sender: Any) {
        guard let expense = self.storyboard?.instantiateViewController(identifier: "CreateExpenseVC") as? CreateExpenseVC else {
            return
        }
        expense.navigationController?.title = "지출 작성"
        self.navigationController?.pushViewController(expense, animated: true)
    }
}

// MARK: - CollectionViewLayoutDelegate
extension MainCollectionVC: PinterestTypeLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, sizeIndexPath: IndexPath) -> CGFloat {
        let returnSize: CGFloat?
        switch sizeIndexPath.row {
        case 0 :
            returnSize = 100
        case 1 :
            returnSize = 120
        case 2 :
            returnSize = 150
        case 3 :
            returnSize = 130
        case 4 :
            returnSize = 200
        default :
            returnSize = 170
        }
        
        return returnSize!
    }
}

// MARK: - UICollectionViewDataSource
extension MainCollectionVC {


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataManage.list.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
        
        cell.backgroundColor = getRandomColor()
        
        let category = self.dataManage.list[indexPath.row].value(forKey: "name") as? String
        
        cell.categoryLabel.text = category
        
        return cell
    }
}

// MARK: - Util
extension MainCollectionVC {
    
    private func getRandomColor()->UIColor{
        
            let red = CGFloat(arc4random()) / CGFloat(UInt32.max)
            let green = CGFloat(arc4random()) / CGFloat(UInt32.max)
            let blue = CGFloat(arc4random()) / CGFloat(UInt32.max)
            
            return UIColor.init(red: red, green: green, blue: blue, alpha: 1)
        }
}
