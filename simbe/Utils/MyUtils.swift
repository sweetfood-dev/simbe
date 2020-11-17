//
//  MyUtils.swift
//  simbe
//
//  Created by 권지수 on 2020/11/04.
//

import Foundation
import UIKit


extension Date {
    func toString(format: String = "yyyyMMdd") -> String{
        let mFormat = DateFormatter()
        mFormat.dateFormat = format
        return mFormat.string(from: self)
    }    
}

extension Int {
    func toString() -> String {
        return String(self)
    }
}

extension String {
    func toInt() -> Int {
        guard let val = Int(self) else {
            return 0
        }
        return val
    }
}

extension UIView {
    //    var topSafeAreaHeight: CGFloat = 0
    //    var bottomSafeAreaHeight: CGFloat = 0
    //
    //      if #available(iOS 11.0, *) {
    //        let window = UIApplication.shared.windows[0]
    //        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
    //        topSafeAreaHeight = safeFrame.minY
    //        bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
    //      }
    //
    //    print("\(topSafeAreaHeight)\n\(bottomSafeAreaHeight)")
    func getTopSafeAreaHeight() -> CGFloat {
        var topSafeAreaHeight: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            topSafeAreaHeight = safeFrame.minY
            return topSafeAreaHeight
        }else {
            return 0
        }
    }
    
    func getBottomSafeAreaHeight() -> CGFloat {
        var bottomSafeAreaheight: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            bottomSafeAreaheight = window.frame.maxY - safeFrame.maxY
            
            return bottomSafeAreaheight
        }else {
            return 0
        }
    }
    
    public var safeAreaFrame: CGRect {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide.layoutFrame
        }
        return bounds
    }
}
