//
//  Extension.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/25.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

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
