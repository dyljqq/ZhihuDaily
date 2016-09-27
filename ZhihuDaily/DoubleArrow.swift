//
//  DoubleArrow.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/27.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class DoubleArrow: UIView {
    
    let arrowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 0))
        path.addLineToPoint(CGPointMake(10, 10))
        path.addLineToPoint(CGPointMake(20, 0))
        
        path.moveToPoint(CGPointMake(0, 5))
        path.addLineToPoint(CGPointMake(10, 15))
        path.addLineToPoint(CGPointMake(20, 5))
        
        layer.path = path.CGPath
        layer.frame = CGRectMake(0, 0, 13, 13)
        layer.fillColor = nil
        layer.lineWidth = 1.0
        layer.strokeColor = lineColor.CGColor
        layer.lineCap = kCALineJoinRound
        layer.lineJoin = kCALineCapRound
        layer.fillMode = kCAFillModeForwards
        
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(arrowLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
