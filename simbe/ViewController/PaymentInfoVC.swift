//
//  PaymentInfoVC.swift
//  simbe
//
//  Created by 권지수 on 2020/11/12.
//

import UIKit
import CoreData

class PaymentInfoVC: UITableViewController {

    var paymentList: [PaymentInfo]!
    let cellIdentifier = "paymentInfoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUi()
    }
    
    func initUi(){
        // 헤더뷰 설정
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10 , height: 50))
        let categoryLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10 , height: 50))
        let priceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10 , height: 50))
        
        dateLabel.text = "날짜"
        dateLabel.textAlignment = .center
        categoryLabel.text = "항목"
        categoryLabel.textAlignment = .center
        priceLabel.text = "금액"
        priceLabel.textAlignment = .center
        
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(priceLabel)
        
        headerView.addSubview(stackView)
        
        tableView.tableHeaderView = headerView
        
        // 셀 높이 설정
//        tableView.estimatedRowHeight = 100
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        let paymentList = category?.paymentInfo as? Set<PaymentInfo>
        print("count : \(paymentList.count)")
        return paymentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? paymentInfoCell
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print("\(paymentList[indexPath.row].date!)")
        cell?.dateLabel.text = formatter.string(from:paymentList[indexPath.row].date!)
        cell?.categoryLabel.text = paymentList[indexPath.row].category?.name
        cell?.priceLabel.text = paymentList[indexPath.row].price.description + " 원"

        return cell!
    }
}
