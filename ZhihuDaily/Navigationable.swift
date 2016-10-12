//
//  Navigationable.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/30.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

protocol Navigationable {
    
    func setLeftNavigationItem(itemIcon: String)
    
}

extension Navigationable where Self: UIViewController {
    
    func setLeftNavigationItem(itemIcon: String) {
        let left = UIBarButtonItem(image: UIImage(named: itemIcon), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        left.tintColor = whiteColor
        navigationItem.setLeftBarButtonItem(left, animated: true)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
}

