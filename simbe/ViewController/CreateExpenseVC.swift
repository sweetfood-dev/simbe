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

enum GuestureType: Int {
    case date = 0
    case price = 1
}

class CreateExpenseVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var detailTextfield: UITextField!
    
    @IBOutlet var paymentTypeSegment: UISegmentedControl!
    
    let reuseId = "expanseTableCell"
    let dataManager = DataMO.shared
    
    weak var modalVC: ModelVC!
    
    var dateText: String {
        get {
            return dateLabel.text ?? ""
        }
        set {
            dateLabel.text = newValue
        }
    }
    
    var priceText: String {
        get {
            return priceLabel.text ?? "0"
        }
        set {
            priceLabel.text = newValue
        }
    }
    
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

// MARK: - Life cycle, Action Method, UI
extension CreateExpenseVC {
    override func viewDidLoad() {
        initSetup()
        
    }
    
    func initSetup(){
        
        setGesturee()
        setUi()
    }
    
    func setGesturee(){
        dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paymentLabelAction(sender:))))
        priceLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paymentLabelAction(sender:))))
    }
    func setUi(){
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let toDay = format.string(from: Date())
        dateLabel.text = toDay
    }
    
    func setupSubVC(){
        if self.modalVC == nil {
            self.modalVC = self.storyboard?.instantiateViewController(identifier: "ModalVC") as? ModelVC
            let top = self.view.getTopSafeAreaHeight()
            let bottom = self.view.getBottomSafeAreaHeight()
            let viewHeight = self.view.frame.size.height - top - bottom
            
            self.modalVC.delegate = self
            self.modalVC.view.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: viewHeight / 2)
            self.view.addSubview(self.modalVC.view)
            self.addChild(self.modalVC!)
            self.modalVC.didMove(toParent: self)
//            self.modalVC = modalVC
        }
    }
    
    func showViewController(){
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.modalVC?.view.frame.origin.y = (self.view.frame.size.height / 2) - self.view.getBottomSafeAreaHeight()
            }, completion: nil)
    }
    
    func closeViewController() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            let top = self.view.getTopSafeAreaHeight()
            let bottom = self.view.getBottomSafeAreaHeight()
            let viewHeight = self.view.frame.size.height - top - bottom
            
            self.modalVC?.view.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: viewHeight / 2)
        }, completion: {
            if $0 == true {
                self.modalVC?.view.removeFromSuperview()
                self.modalVC?.removeFromParent()
                self.modalVC = nil
            }
        })
    }
    
    @objc func paymentLabelAction(sender: UITapGestureRecognizer) {
        let label = sender.view as? UILabel
        let tagVal = label?.tag
        
        switch tagVal {
        case GuestureType.date.rawValue:
            setupSubVC()
            self.modalVC.setCalendar()
            showViewController()
            break
        case GuestureType.price.rawValue:
            setupSubVC()
            self.modalVC.setCalcurator()
            showViewController()
            break
        default:
            break
        }
        
    }
}

