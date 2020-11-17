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
        let tabBarHeight: CGFloat! = self.tabBarController?.tabBar.frame.size.height
        switch sizeIndexPath.row {
        case 0 :
            returnSize = (self.collectionView.frame.height - self.view.getTopSafeAreaHeight() - tabBarHeight) * 0.30 * 2
        case 1 :
            returnSize = (self.collectionView.frame.height - self.view.getTopSafeAreaHeight() - tabBarHeight) * 0.25 * 2
        case 2 :
            returnSize = (self.collectionView.frame.height - self.view.getTopSafeAreaHeight() - tabBarHeight) * 0.20 * 2
        case 3 :
            returnSize = (self.collectionView.frame.height - self.view.getTopSafeAreaHeight() - tabBarHeight) * 0.15 * 2
        case 4 :
            returnSize = (self.collectionView.frame.height - self.view.getTopSafeAreaHeight() - tabBarHeight) * 0.10 * 2
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
        print("paymentInfo count : \(paymentInfo.count)")
        var paymentInfoArray = categoryList?[indexPath.row].getSortedDateArray()
        payment.paymentList = paymentInfoArray
        self.navigationController?.pushViewController(payment, animated: true)
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
