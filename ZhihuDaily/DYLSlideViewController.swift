//
//  DYLSlideViewController.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/30.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class DYLSlideViewController: UIViewController {
    
    var slide: Bool = false {
        didSet {
            if slide {
                open()
            } else {
                close()
            }
        }
    }
    
    var leftViewController: UIViewController!
    var centerViewController: UIViewController!
    
    var leftView: UIView!
    var centerView: UIView!
    
    init(left: UIViewController, center: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        
        leftViewController = left
        centerViewController = center
        
        leftView = leftViewController.view
        centerView = centerViewController.view
        
        self.view.addSubview(leftViewController.view)
        self.view.addSubview(centerViewController.view)
        
        leftView.frame = CGRectMake(-screenSize.width / 2, 0, screenSize.width / 2, screenSize.height)
        centerView.frame = self.view.bounds
        
    }
    
    convenience init() {
        self.init(left: UIViewController(), center: UIViewController())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func open() {
        UIView.animateWithDuration(0.5) {
            self.centerView.center = CGPoint(x: screenSize.width, y: screenSize.height / 2)
            self.leftView.center = CGPoint(x: screenSize.width / 4, y: screenSize.height / 2)
        }
    }
    
    private func close() {
        UIView.animateWithDuration(0.5) {
            self.centerView.center = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
            self.leftView.center = CGPoint(x: -screenSize.width / 4, y: screenSize.height / 2)
        }
        print("aaa: \((self.centerViewController as! UINavigationController).topViewController.self)")
    }
    
    
}
