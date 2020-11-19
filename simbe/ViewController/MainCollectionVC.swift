//
//  MainCollectionVC.swift
//  simbe
//
//  Created by 권지수 on 2020/10/30.
//

import UIKit

private let reuseIdentifier = "MainCollectionCell"

class MainCollectionVC: UICollectionViewController {
    let testPercent = [30,25,20,15,10]
    let context = AppDelegate.context
    var categoryList: [PayCategory]? {
        get {
            PayCategory.getItemList(context: context)
        }
        set {
        }
    }
    var tabBarHeight: CGFloat {
        return self.tabBarController?.tabBar.frame.size.height ?? 0
    }
    var collectionViewContentHeight: CGFloat {
        get{
            return (self.collectionView.frame.height - self.view.getTopSafeAreaHeight() - tabBarHeight)
        }
    }
    
    override func viewDidLoad() {
        if let layout = collectionView?.collectionViewLayout as? PinterestTypeLayout {
            layout.delegate = self
        }
        
        categoryList = PayCategory.getItemList(context: context)
        
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
        expense.navigationItem.title = "지출 작성"
        self.navigationController?.pushViewController(expense, animated: true)
    }
}

// MARK: - CollectionViewLayoutDelegate
extension MainCollectionVC: PinterestTypeLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, sizeIndexPath: IndexPath) -> CGFloat {
        let returnSize: CGFloat?
        switch sizeIndexPath.row {
        case 0 :
            returnSize = collectionViewContentHeight * 0.30 * 2
        case 1 :
            returnSize = collectionViewContentHeight * 0.25 * 2
        case 2 :
            returnSize = collectionViewContentHeight * 0.20 * 2
        case 3 :
            returnSize = collectionViewContentHeight * 0.15 * 2
        case 4 :
            returnSize = collectionViewContentHeight * 0.10 * 2
        default :
            returnSize = 0
        }
        
        return returnSize!
    }
}

// MARK: - UICollectionViewDataSource
extension MainCollectionVC {


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryList?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
        
        cell.backgroundColor = getRandomColor()
        cell.categoryLabel.text = categoryList?[indexPath.row].name
        cell.percentLabel.text = testPercent[indexPath.row].toString() + "%"
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 카테고리안에 결제 정보가 있는지 확인
        guard let paymentInfo = categoryList?[indexPath.row].paymentInfo as? Set<PaymentInfo> else {
            // 없으면 종료
            return
        }
        
        // 있으면 카테고리 정보를 넘겨주어 PaymentViewController로 이동
        guard let payment = self.storyboard?.instantiateViewController(identifier: "PaymentlViewcontroller") as? PaymentInfoVC else {
            return
        }
        payment.navigationItem.title = categoryList?[indexPath.row].name
        let categoryName = categoryList?[indexPath.row].name ?? ""
        print("\(Date().startOfDay)\n \(Date().endOfDay)\n \(Date().startOfMonth)\n \(Date().endOfMonth)")
        let from = Date().startOfMonth
        let to = Date().endOfDay
        if let paymentInfoArray = PaymentInfo.getSelectDate(context: context, category: categoryName, from: from, to: to) {
            payment.paymentList = paymentInfoArray
            self.navigationController?.pushViewController(payment, animated: true)
        }
        
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

extension Date {
    var startOfDay: Date {
        return (Calendar.current.startOfDay(for: self) + 32400)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let cal = Calendar.current
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)! + 32400
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
}
