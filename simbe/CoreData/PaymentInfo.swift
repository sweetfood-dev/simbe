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
        
        return payInfo
    }
}
