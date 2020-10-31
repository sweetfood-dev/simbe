//
//  DataMO.swift
//  simbe
//
//  Created by 권지수 on 2020/10/29.
//

import UIKit
import CoreData

class DataMO {
    private let entityName: String = "PaymetnInfo"
    
    lazy var list: [NSManagedObject] = {
        return fetch()
    }()
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        return context
    }()
    
    func fetch() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        let result = try! context.fetch(fetchRequest) // 데이터 가져오기
        
        return result
    }
    
    func save(item: String, price: String) -> Bool {
        let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
            
        object.setValue(item, forKey: "item")
        object.setValue(Int(price), forKey: "price")
        object.setValue(Date(), forKey: "date")
        
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
}
