//
//  Item.swift
//  simbe
//
//  Created by 권지수 on 2020/11/10.
//

import UIKit
import CoreData

class PayCategory: NSManagedObject {
        
    class func findOrCreateItem(name: String, context: NSManagedObjectContext) throws -> PayCategory{
        // name을 가진 Item 검색
        let request :NSFetchRequest<PayCategory> = PayCategory.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let finded = try context.fetch(request)
            // 있으면 return
            if finded.count > 0 {
                // finded의 갯수가 1이면 정상, 그 이상이면 옳바르지않은 결과값
                // Item은 소비항목이기 때문에 1개 이상일 수 없음
                assert(finded.count == 1, "Item.findOrCreateItem -- database inconsistency")
                return finded.first!
            }
        }catch {
            throw error
        }
        
        // 없으면 생성 후 return
        let payCategory = PayCategory(context: context)
        payCategory.name = name
        
        return payCategory
    }
    
    class func getItemList(context: NSManagedObjectContext) throws -> [PayCategory] {
        let request: NSFetchRequest<PayCategory> = PayCategory.fetchRequest()
        do {
            let itemList = try context.fetch(request)
            return itemList
        }catch {
            throw error
        }
    }
}
