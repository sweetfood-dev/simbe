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
    private var collectionViewContentHeight: CGFloat {
        return collectionView.frame.size.height
    }
    
    private var fromDate = Date().startOfMonth
    private var toDate = Date().endOfDay
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView.collectionViewLayout as? PinterestTypeLayout {
            layout.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.reloadData()
    }
}

// MARK: - CollectionLayoutDelegate
extension HistoryCollectionVC: PinterestTypeLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeIndexPath: IndexPath) -> CGFloat {
        guard let categories = getMonthExpense(context: context, from: fromDate, to: toDate) else {
            return 0.0
        }
        var returnSize: CGFloat = 0
        if  categories.count > 0 {
            let percent = categories[sizeIndexPath.row].percentage
            returnSize = CGFloat(percent * Double(2)) * collectionViewContentHeight
        }
        return returnSize
    }
}

extension HistoryCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let list = getCategoryList(context: context)
        return list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("kjsDebug cellForItemAt")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HistoryCollectionViewCell
        let itemList = getMonthExpense(context: context, from: fromDate, to: toDate)
        let percent = (itemList?[indexPath.row].percentage ?? 0 ) * 100
        print("kjsDebug percent: \(percent)")
        cell.categoryLabel.text = itemList?[indexPath.row].name
        cell.percentLabel.text = round(percent).description + "%"
        cell.backgroundColor = getRandomColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let paymentInfoVC = storyboard?.instantiateViewController(identifier: "PaymentlViewcontroller") as? PaymentInfoVC else {
            return
        }
        
        guard let itemList = getMonthExpense(context: context, from: fromDate, to: toDate) else {
            return
        }
        
        guard let categoryName = itemList[indexPath.row].name,
              let paymentInfo = PaymentInfo.getSelectDate(context: context, category: categoryName, from: fromDate, to: toDate) else {
            return
        }
        
        paymentInfoVC.paymentList = paymentInfo
        self.navigationController?.pushViewController(paymentInfoVC, animated: true)
    }
    
}

// MARK: - CoreData
extension HistoryCollectionVC {
    private func getCategoryList(context: NSManagedObjectContext) -> [PayCategory]? {
        guard let categoryList = PayCategory.getItemList(context: context) else {
            return nil
        }
        
        return categoryList
    }
    
    private func getSortedCategoryList(context: NSManagedObjectContext) -> [PayCategory]? {
        guard let categoryList = getCategoryList(context: context) else {
            return nil
        }
        
        return categoryList.sorted(by: {
            $0.percentage > $1.percentage
        })
    }
    
    private func getMonthExpense(context: NSManagedObjectContext, from: Date, to: Date) -> [PayCategory]?{
        guard let categoryList = getCategoryList(context: context) else {
            return nil
        }
        var totalPrice = 0.0
        categoryList.forEach {
            $0.currentMonthPrice = PaymentInfo.getPeriodExpending(context: context, category: $0.name!, from: from, to: to)
            totalPrice = totalPrice + Double($0.currentMonthPrice)
        }
        
        categoryList.forEach {
            $0.percentage = Double($0.currentMonthPrice) / totalPrice
        }
        
        return categoryList.sorted(){
            $0.percentage > $1.percentage
        }
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
