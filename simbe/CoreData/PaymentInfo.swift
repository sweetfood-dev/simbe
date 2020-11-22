//
//  PaymentInfo.swift
//  simbe
//
//  Created by 권지수 on 2020/11/10.
//

import UIKit
import CoreData

struct PaymentInfoData {
    var date: Date
    var detail: String?
    var paymenttype: Int16
    var price: Int64
    var category: PayCategory
}

class PaymentInfo: NSManagedObject {
    class func createInfo(info: PaymentInfoData, context: NSManagedObjectContext) -> PaymentInfo{
        // 없으면 생성 후 return
        let payInfo = PaymentInfo(context: context)
        payInfo.date = info.date + 32400
        payInfo.detail = info.detail
        payInfo.paymenttype = info.paymenttype
        payInfo.price = info.price
        payInfo.category = info.category
        return payInfo
    }
    
    class func getItemList(context: NSManagedObjectContext) -> [PaymentInfo]? {
        let request: NSFetchRequest<PaymentInfo> = PaymentInfo.fetchRequest()
        
        let itemList = try? context.fetch(request)
        return itemList
    }
    
    class func getSelectDate(context: NSManagedObjectContext, category: String, from: Date, to: Date) -> [PaymentInfo]? {
        let fromNsDate = from as NSDate
        let toNsDate = to as NSDate
        let request :NSFetchRequest<PaymentInfo> = PaymentInfo.fetchRequest()
        request.predicate = NSPredicate(format: "category.name == %@ AND date => %@ AND date =< %@",category, fromNsDate, toNsDate)
        var itemList = try? context.fetch(request)        
        if itemList != nil {
            itemList = itemList?.sorted(by: {
                $0.date! < $1.date!
            })
        }
        return itemList
    }
    
    class func getPeriodExpending(context: NSManagedObjectContext, category: String, from: Date, to: Date) -> Int {
        guard let itemList = getSelectDate(context: context, category: category, from: from, to: to) else {
            return 0
        }
        var totalPrice = 0
        for item in itemList {
            totalPrice = totalPrice + Int(item.price)
        }
        
        return totalPrice
    }
}
