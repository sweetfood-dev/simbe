//
//  DataMO.swift
//  simbe
//
//  Created by 권지수 on 2020/10/29.
//

import UIKit
import CoreData

class DataMO {
    static let shared = DataMO()
    
    private let entityNamePayment: String = "PaymentInfo"
    private let entityNameItem: String = "Item"
    
    lazy var list: [ItemMO] = {
        return fetch()
    }()
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        return context
    }()
    
    func fetch() -> [ItemMO] {
        let fetchRequest = NSFetchRequest<ItemMO>(entityName: entityNameItem)
        
        let result = try! context.fetch(fetchRequest) // 데이터 가져오기
        
        return result
    }
    
    func save(name: String, paymentInfo: PaymentInfoMO?) -> Bool {
        let object = NSEntityDescription.insertNewObject(forEntityName: entityNameItem, into: context) as! ItemMO
            
        object.setValue(name, forKey: "name")
        if let paymentInfo = paymentInfo{
            object.addToPaymentinfo(paymentInfo)
        }
        
        do {
            try context.save()
            list.append(object)
            print("save success")
            return true
        } catch {
            context.rollback()
            print("save failed")
            return false
        }
    }
    
    func makePaymentInfo(price: String) -> PaymentInfoMO {
        let object = NSEntityDescription.insertNewObject(forEntityName: entityNamePayment, into: context) as! PaymentInfoMO
        
        object.setValue(Int(price), forKey: "price")
        
        return object
    }
}
