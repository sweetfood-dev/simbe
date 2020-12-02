//
//  MainCollectionVC.swift
//  simbe
//
//  Created by 권지수 on 2020/10/30.
//

import UIKit

private let reuseIdentifier = "MainCollectionCell"

class MainCollectionVC: UICollectionViewController {
    let context = AppDelegate.context
    var categoryList: [PayCategory]? {
        get {
            PayCategory.getItemList(context: context)?.sorted(by: {
                $0.percentage > $1.percentage
            })
        }
        set {
        }
    }
    
    var fromDate = Date().startOfMonth
    var toDate = Date().endOfDay
    @IBOutlet var viewType: UIBarButtonItem!
    
    var tabBarHeight: CGFloat {
        return self.tabBarController?.tabBar.frame.size.height ?? 0
    }
    // 콜렉션뷰 높이
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
    
    func getCategorySortedPercent() -> Array<PayCategory>{
        guard let copyCategory = categoryList else {
            return Array<PayCategory>()
        }
        
        // 카테고리별 이번 달 총 지출과 지출 비율을 계산
        var categories = Array<PayCategory>()
        var totalCost = 0.0
        print("fromDate : \(fromDate)")
        print("toDate : \(toDate)")
        for category in copyCategory {
            category.currentMonthPrice = PaymentInfo.getPeriodExpending(context: context,
                                                                        category: category.name!,
                                                                        from: fromDate,
                                                                        to: toDate)
            totalCost = totalCost + Double(category.currentMonthPrice)
            if category.currentMonthPrice > 0 {
                categories.append(category)
            }
            print("category.currentMonthPrice [\(category.name!)]: \(category.currentMonthPrice)")
        }
        
        for i in 0 ..< categories.count{
            if categories[i].currentMonthPrice > 0 {
                categories[i].percentage = Double(categories[i].currentMonthPrice) / totalCost
            }
        }
        return categories.sorted(by: {
            $0.percentage > $1.percentage
        })
    }
    
    
    @IBAction func add(_ sender: Any) {
        guard let expense = self.storyboard?.instantiateViewController(identifier: "CreateExpenseVC") as? CreateExpenseVC else {
            return
        }
        expense.navigationItem.title = "지출 작성"
        self.navigationController?.pushViewController(expense, animated: true)
    }
    @IBAction func sortCollectionView(_ sender: Any) {
        let alert = UIAlertController(title: "보기 선택", message: "어떤 기준으로 보시겠습니까?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "오늘", style: .default){ [weak self] _ in
            guard let self = self else {
                return
            }
            self.viewType.title = "오늘"
            self.fromDate = Date().startOfDay
            self.toDate = Date().endOfDay
            self.collectionView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "이번 주", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.viewType.title = "이번 주"
            self.fromDate = Date().startOfWeek
            self.toDate = Date().endOfDay
            self.collectionView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "이번 달", style: .default){ [weak self] _ in
            guard let self = self else {
                return
            }
            self.viewType.title = "이번 달"
            self.fromDate = Date().startOfMonth
            self.toDate = Date().endOfDay
            self.collectionView.reloadData()
        })
//        alert.addAction(UIAlertAction(title: "결제수단", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
        
        self.present(alert, animated: false, completion: nil)
    }
    
}

// MARK: - CollectionViewLayoutDelegate
extension MainCollectionVC: PinterestTypeLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, sizeIndexPath: IndexPath) -> CGFloat {
        var returnSize: CGFloat = 0
        let categories = getCategorySortedPercent()
        if  categories.count > 0 {
            let percent = categories[sizeIndexPath.row].percentage
            returnSize = CGFloat(percent * Double(2)) * collectionViewContentHeight
        }
        return returnSize
    }
}

// MARK: - UICollectionViewDataSource
extension MainCollectionVC {
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        return categoryList?.count ?? 0
        return  getCategorySortedPercent().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
        let categories = getCategorySortedPercent()
        let percent = categories[indexPath.row].percentage * 100
        
        cell.backgroundColor = categories[indexPath.row].color as? UIColor
        cell.categoryLabel.text = categories[indexPath.row].name
        cell.percentLabel.text = round(percent).description + "%"
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
        let categories = getCategorySortedPercent()
        guard categories.count > 0 else {
            return
        }
        
        payment.navigationItem.title = categories[indexPath.row].name
        
        let categoryName = categories[indexPath.row].name ?? ""        
        if let paymentInfoArray = PaymentInfo.getSelectDate(context: context, category: categoryName, from: fromDate, to: toDate) {
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
//        let cal = Calendar.current
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
    
//    var startOfWeek: Date {
//        let components = Calendar.current.dateComponents([.weekOfYear], from: startOfDay)
//        return Calendar.current.date(from: components)! + 32400
//    }
    
    var startOfWeek: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfDay))! + 32400
    }
}
