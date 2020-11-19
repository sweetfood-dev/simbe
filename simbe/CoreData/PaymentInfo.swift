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
        payInfo.date = info.date
        payInfo.detail = info.detail
        payInfo.paymenttype = info.paymenttype
        payInfo.price = info.price
        payInfo.category = info.category
        print("Create Date \(info.date)")
        return payInfo
    }
    
    
    class func getSelectDate(context: NSManagedObjectContext, category: String, from: Date, to: Date) -> [PaymentInfo]? {
        let fromNsDate = from as NSDate
        let toNsDate = to as NSDate
        
        print("from : \(from) to : \(to)")
        
        let request :NSFetchRequest<PaymentInfo> = PaymentInfo.fetchRequest()
//        request.predicate = NSPredicate(format: "category.name == %@ AND %K < %@ AND %K > %@",category, #keyPath(PaymentInfo.date),fromNsDate, #keyPath(PaymentInfo.date), toNsDate)
        request.predicate = NSPredicate(format: "category.name == %@ AND date > %@ AND date < %@",category, fromNsDate, toNsDate)
        
        var itemList = try? context.fetch(request)
        if itemList != nil {
            itemList = itemList?.sorted(by: {
                $0.date! < $1.date!
            })
        }
        return itemList
    }
}

//let paymentInfo = (self.paymentInfo as? Set<PaymentInfo>) ?? Set<PaymentInfo>()
//
//var paymentInfoArr = Array(paymentInfo)
//if paymentInfoArr.count > 0 {
//    paymentInfoArr = paymentInfoArr.sorted(by: {
//        $0.date! < $1.date!
//    })
//}
//return paymentInfoArr
