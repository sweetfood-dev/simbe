//
//  CreateExpenseVC.swift
//  simbe
//
//  Created by 권지수 on 2020/10/31.
//

import UIKit
import CoreData

enum PaymentType: Int {
    
    case checkCard = 0
    case creditCard = 1
    case cash = 2
    
}

enum GuestureType: Int {
    case date = 0
    case price = 1
}

class CreateExpenseVC: UIViewController{

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var detailTextView: UITextView!
    
    @IBOutlet var paymentTypeSegment: UISegmentedControl!
    
    let reuseId = "expanseTableCell"
    
    weak var modalVC: ModelVC!
    
    let context = AppDelegate.context
    
    var categoryList: [PayCategory]?
    
    var dateText: String {
        get {
            return dateLabel.text ?? ""
        }
        set {
            dateLabel.text = newValue
        }
    }
    
    var priceText: String? {
        get {
            return priceLabel.text
        }
        set {
            priceLabel.text = newValue
        }
    }
    
    var detailText: String {
        get {
            return detailTextView.text
        }
        set {
            detailTextView.text = newValue
        }
    }
    
    var selectedCategory: PayCategory?
    
    let bottomArea = 40.0
    
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
            _ = try? PayCategory.findOrCreateItem(name: category, context: context)
            do {
                try context.save()
                categoryList = PayCategory.getItemList(context: context)
                self.tableView.reloadData()
             }catch {
                print("saved Item failed \(error.localizedDescription)")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: false, completion: nil)
    }
    
    @IBAction func addExpense(_ sender: Any) {
        addLogic(){ [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func continueExpanse(_ sender: Any) {
        addLogic() { [weak self] in
            self?.setUi()
        }
    }
    @IBAction func addDetailes(_ sender: Any) {
        detailTextView.resignFirstResponder()
    }
    
    func addLogic(success: (() -> ())? = nil ){
        guard let category = selectedCategory else {
            let alert = UIAlertController(title: "알림", message: "카테고리를 선택해야 합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: false, completion: nil)
            return
        }
        
        guard let priceVar = Int(priceText!) else {
            let alert = UIAlertController(title: "알림", message: "금액을 입력해야 합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: false, completion: nil)
            return
        }
        
        
        let dateString = dateText
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        format.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = format.date(from: dateString)!
        let detail = detailText
        let paymentType = NSNumber(value:paymentTypeSegment.selectedSegmentIndex)
        let price = NSNumber(value: priceVar)
        let paymentInfoData = PaymentInfoData(date: date, detail: detail, paymenttype: paymentType.int16Value, price: price.int64Value, category: category)
        _ = PaymentInfo.createInfo(info: paymentInfoData, context: context)
        do {
            try context.save()
            success?()
        }catch {
            print("save PaymentInfo error \(error.localizedDescription)")
        }
    }
}

// MARK: - TableView DataSource
extension CreateExpenseVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! ExpanseTableViewCell
        cell.categoryLabel?.text = categoryList?[indexPath.row].name
        return cell
    }
}
// MARK: - TableView Delegate
extension CreateExpenseVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoryList?[indexPath.row]
    }
}

// MARK: - Life cycle, Action Method, UI
extension CreateExpenseVC {
    override func viewDidLoad() {
        initSetup()
        detailTextView.delegate = self
        
        categoryList = PayCategory.getItemList(context: context)
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
        
        priceText = "금액을 입력해 주세요."
        
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.borderColor = UIColor.black.cgColor
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
        case GuestureType.price.rawValue:
            setupSubVC()
            self.modalVC.setCalcurator()
            showViewController()
        default:
            break
        }
        
    }
}

// MARK: - Touches Method
extension CreateExpenseVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - NOtification Method
extension CreateExpenseVC {
    
    @objc func keyboardWillHide(noti: Notification){
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillShow(noti: Notification){
        guard let userInfo = noti.userInfo else {
            return
        }
        
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        self.view.frame.origin.y = -keyboardHeight + self.view.safeAreaInsets.bottom + CGFloat(bottomArea)
    }
}
// MARK: - TextViewDelegate
extension CreateExpenseVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}
