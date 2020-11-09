//
//  ModelVC.swift
//  simbe
//
//  Created by 권지수 on 2020/11/05.
//

import UIKit
import FSCalendar

enum FuncType: Int {
    case deleteAll = 0
    case delete = 1
    case apply = 2
}

class ModelVC: UIViewController {
    
    @IBOutlet var mCalendar: FSCalendar!
    @IBOutlet var mCalcurator: UIView!
    
    @IBOutlet var mathResult: UILabel!
    
    var mathResultText: String {
        get {
            return mathResult.text ?? "0"
        }
        
        set {
            mathResult.text = newValue
        }
    }
    
    var delegate: CreateExpenseVC?
    let btnHeight: CGFloat = 30
    
    let brain = CalcuratorBrain()
    var isTyping = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mCalendar.isHidden = true
        mCalcurator.isHidden = true
                                                                                          }
    
    @IBAction func closedBtn(_ sender: Any) {
        delegate?.closeViewController()
    }
    
    
    @IBAction func calNumAction(_ sender: UIButton) {
        let num = sender.tag.toString()
        if mathResultText == "0" {
            mathResultText = num
        }else {
            if isTyping {
                mathResultText = mathResultText + num
            }else {
                mathResultText = num
                isTyping = true
            }
        }
    }
    
    @IBAction func calOpAction(_ sender: UIButton) {
        guard let symbol = sender.titleLabel?.text else {
            return
        }
        isTyping = false
        brain.setOperand(operand: mathResultText.toInt())
        brain.performOperation(symbol: symbol)
        mathResultText = brain.result.toString()
        
    }
    
    @IBAction func calFuncAction(_ sender: UIButton) {
        let type = FuncType(rawValue: sender.tag)!
        
        switch type {
        case .apply:
            delegate?.priceText = mathResultText
            delegate?.closeViewController()
        case .delete:
            guard mathResultText.count > 0 else {
                return
            }
            mathResultText.removeLast()
            if mathResultText.count < 1 {
                mathResultText = "0"
            }
            brain.setOperand(operand: mathResultText.toInt())
        case .deleteAll:
            mathResultText = "0"
            brain.setOperand(operand: mathResultText.toInt())
        }
    }
    
    
    deinit {
        print("modal deinit")
    }
}

// MARK: ViewSet
extension ModelVC {
    func setCalendar(){
        mCalendar.isHidden = false
        mCalendar.frame = CGRect(x: 0, y: btnHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - btnHeight)
        
        mCalendar.appearance.headerDateFormat = "YYYY년 M월"
        mCalendar.locale = Locale(identifier: "ko_KR")
        
        mCalendar.appearance.weekdayTextColor = .black
        mCalendar.calendarWeekdayView.weekdayLabels.first?.textColor = .red
        mCalendar.calendarWeekdayView.weekdayLabels.last?.textColor = .blue
    }
    
    func setCalcurator() {
        mCalcurator.isHidden = false
        mCalcurator.frame = CGRect(x: 0, y: btnHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - btnHeight)
    }
}
// MARK: - FSCalendar
extension ModelVC: FSCalendarDelegate, FSCalendarDataSource {
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let selectedDate = format.string(from: date)
        
        delegate?.dateText = selectedDate
        delegate?.closeViewController()
    }
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    }
}

// MARK: - Calcurate
extension ModelVC {
}

