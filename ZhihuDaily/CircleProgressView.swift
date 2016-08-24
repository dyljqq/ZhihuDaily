//
//  CircleProgressView.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/24.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class CircleProgressView: UIView {
    
    struct Constant {
        static let lineWidth: CGFloat = 5.0
        static let inset: CGFloat = 5.0
        static let progressColor = whiteColor
    }
    
    var progress: Int = 0 {
        didSet {
            if progress > 100 {
                progress = 100
            } else if progress < 0 {
                progress = 0
            }
        }
    }
    
    private let path = UIBezierPath()
    
    private lazy var progressLayer = CAShapeLayer()
    
    init() {
        super.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        path.addArcWithCenter(CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds)),
                              radius: bounds.size.width/2 - Constant.lineWidth - Constant.inset,
                              startAngle: angleToRadian(-90), endAngle: angleToRadian(270), clockwise: true)
        self.progressLayer.frame = bounds
        self.progressLayer.fillColor = clearColor.CGColor
        self.progressLayer.strokeColor = Constant.progressColor.CGColor
        self.progressLayer.lineWidth = Constant.lineWidth
        self.progressLayer.path = self.path.CGPath
        self.progressLayer.strokeStart = 0
        
        setup()
    }
    
    private func setup() {
        layer.addSublayer(self.progressLayer)
    }
    
    func setProgress(progress: Int, animated anim: Bool) {
        if anim {
            setProgress(progress, withDuration: 0.6)
        } else {
            self.progressLayer.strokeEnd = CGFloat(progress)/100.0
        }
    }
    
    func setProgress(progress: Int, withDuration duration: Double) {
        self.progress = progress
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0.0
        animation.toValue = CGFloat(self.progress) / 100.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.progressLayer.strokeEnd = CGFloat(self.progress) / 100.0
        self.progressLayer.addAnimation(animation, forKey: "animateCircle")
    }
}

extension CircleProgressView {
    private func angleToRadian(angle: Double)-> CGFloat {
        return CGFloat(angle/Double(180.0) * M_PI)
    }
}
