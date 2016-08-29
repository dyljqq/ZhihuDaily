//
//  CircleProgressView.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/24.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class CircleProgressView: UIView {
    
    var backgroundCircleColor = lightGrayColor
    var progressColor = whiteColor
    var inset: CGFloat = 5.0
    var lineWidth: CGFloat = 5.0
    
    var progress: Int = 0 {
        didSet {
            if progress > 100 {
                progress = 100
            } else if progress < 0 {
                progress = 0
            }
        }
    }
    
    var frontProgress = 0
    
    private let path = UIBezierPath()
    
    private var progressLayer = CAShapeLayer()
    
    private var backgroundLayer = CAShapeLayer()
    
    var showBackgroundLayer: Bool = false {
        didSet {
            self.backgroundLayer.hidden = !showBackgroundLayer
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        self.showBackgroundLayer = false
        self.backgroundColor = clearColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        path.addArcWithCenter(CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds)),
                              radius: bounds.size.width/2 - lineWidth - inset,
                              startAngle: angleToRadian(-90), endAngle: angleToRadian(270), clockwise: true)
        
        self.backgroundLayer.frame = self.bounds
        self.backgroundLayer.fillColor = clearColor.CGColor
        self.backgroundLayer.strokeColor = self.backgroundCircleColor.CGColor
        self.backgroundLayer.lineWidth = self.lineWidth
        self.backgroundLayer.path = self.path.CGPath
        self.backgroundLayer.strokeStart = 0
        self.backgroundLayer.strokeEnd = 1.0
        
        self.progressLayer.frame = bounds
        self.progressLayer.fillColor = clearColor.CGColor
        self.progressLayer.strokeColor = progressColor.CGColor
        self.progressLayer.lineWidth = lineWidth
        self.progressLayer.path = self.path.CGPath
        self.progressLayer.strokeStart = 0
        
        setup()
    }
    
    private func setup() {
        layer.addSublayer(self.backgroundLayer)
        layer.addSublayer(self.progressLayer)
    }
    
    func setProgress(progress: Int, animated anim: Bool) {
        if anim {
            setProgress(progress, withDuration: 0.6)
        } else {
            self.progressLayer.strokeEnd = CGFloat(progress)/100.0
        }
    }
    
    private func setProgress(progress: Int, withDuration duration: Double) {
        
        self.progress = progress
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = CGFloat(frontProgress) / 100.0
        animation.toValue = CGFloat(progress) / 100.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.progressLayer.strokeEnd = CGFloat(self.progress) / 100.0
        self.progressLayer.addAnimation(animation, forKey: "animateCircle")
        
        frontProgress = self.progress
    }
}

extension CircleProgressView {
    private func angleToRadian(angle: Double)-> CGFloat {
        return CGFloat(angle/Double(180.0) * M_PI)
    }
}
