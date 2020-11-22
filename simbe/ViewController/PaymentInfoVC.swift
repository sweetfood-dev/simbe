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
    let context = AppDelegate.context
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let colorPicker = UIColorPickerViewController()
        self.present(colorPicker, animated: false, completion: nil)
    }
    
    override public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = deleteSwipe(indexPath: indexPath)
        let edit = editSwipe(indexPath: indexPath)
        
        let swipeAction = UISwipeActionsConfiguration(actions: [delete, edit])
        
        return swipeAction
    }
}

// MARK: - Tableview Edit Mode Action
extension PaymentInfoVC {
    private func deleteSwipe(indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _,_,_ in
            guard let self = self else {
                return
            }
            self.context.delete(self.paymentList[indexPath.row])
            do {
                try self.context.save()
                self.paymentList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()
            }catch {
                self.context.rollback()
                print("PaymentInfoVC delete data error \(error.localizedDescription)")
            }
        }
        
        return action
    }
    
    private func editSwipe(indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "수정") { [weak self] _,_,_ in
            guard let self = self else {
                return
            }
            let alert = UIAlertController(title: "수정", message: "수정될 금액을 작성해주세요.", preferredStyle: .alert)
            alert.addTextField(){
                $0.text = self.paymentList[indexPath.row].price.description
            }
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                guard let price = alert.textFields?.first?.text else {
                    return
                }
                
                self.paymentList[indexPath.row].price = Int64(price) ?? self.paymentList[indexPath.row].price
                do {
                    try self.context.save()
                    self.tableView.reloadData()
                } catch {
                    print("PaymentInfoVC edit error \(error.localizedDescription)")
                }
            })
            
            self.present(alert, animated: false, completion: nil)
        }
        
        return action
    }
}
