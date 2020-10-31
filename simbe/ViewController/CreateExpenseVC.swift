//
//  CreateExpenseVC.swift
//  simbe
//
//  Created by 권지수 on 2020/10/31.
//

import UIKit

enum PaymentType: Int {
    
    case checkCard = 0
    case creditCard = 1
    case cash = 2
    
}

class CreateExpenseVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var paymentTypeSegment: UISegmentedControl!
    
    let reuseId = "expanseTableCell"
    let dataManager = DataMO.shared
    
    // MARK: - Category Add
    @IBAction func addCategory(_ sender: Any) {

        let alert = UIAlertController(title: "항목추가", message: nil, preferredStyle: .alert)
        
        alert.addTextField() {
            $0.placeholder = "항목명"
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [unowned self] (_) in
            guard let category = alert.textFields?.first?.text, !category.isEmpty else {
                return
            }
            print(category)
            if self.dataManager.save(name: category, paymentInfo: nil) {
                self.tableView.reloadData()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: false, completion: nil)
    }
    
}

// MARK: - TableView DataSource
extension CreateExpenseVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataManager.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! ExpanseTableViewCell
        
        let category = dataManager.list[indexPath.row].value(forKey: "name") as? String
        cell.categoryLabel.text = category
        return cell
    }
        
}

