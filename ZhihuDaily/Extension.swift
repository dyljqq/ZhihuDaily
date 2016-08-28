//
//  Extension.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/25.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit
import SwiftDate

private var overlayKey: Void?

extension UINavigationBar {
    
    private func dyl_overlay()-> UIView? {
        return objc_getAssociatedObject(self, &overlayKey) as? UIView
    }
    
    private func dyl_setOverlay(overlayView: UIView?) {
        objc_setAssociatedObject(self, &overlayKey, overlayView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public var overlay: UIView? {
        get {
            return self.dyl_overlay()
        }
        
        set {
            if newValue == overlay {
                return
            } else {
                guard let newValue = newValue else {
                    self.removeFromSuperview()
                    self.dyl_setOverlay(nil)
                    return
                }
                self.dyl_setOverlay(newValue)
            }
        }
    }
    
    func dyl_setBackgroundColor(backgroundColor: UIColor) {
        if overlay == nil {
            self.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            overlay = UIView(frame: CGRectMake(0, -20, screenSize.width, self.bounds.size.height + 20))
            overlay!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            self .insertSubview(overlay!, atIndex: 0)
        }
        overlay?.backgroundColor = backgroundColor
    }
    
}

extension NSDate {
    func format(format format: String)-> String {
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.stringFromDate(self)
    }
}

extension String {
    func dateString(format: String)-> String {
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = format
        
        guard let date = dateFormat.dateFromString(self) else {
            print("时间不合法")
            return ""
        }
        print("date: \(date)")
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month, .Day, .Weekday], fromDate: date)
        return "\(components.month)月\(components.day)日 \(components.weekday.weekday())"
    }
}

extension Int {
    func weekday()-> String {
        var  str = ""
        switch self {
        case 0: str = "星期日"
        case 1: str = "星期一"
        case 2: str = "星期二"
        case 3: str = "星期三"
        case 4: str = "星期四"
        case 5: str = "星期五"
        case 6: str = "星期六"
        default:
            str = ""
        }
        return str
    }
}

