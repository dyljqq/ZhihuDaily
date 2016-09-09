//
//  DYLSlideMenu.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/29.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

public class DYLSlideMenu: UIView {
    
    public var maxOffset: CGFloat = 50.0
    public var menuColor = UIColor.blueColor()
    public var helperWidth: CGFloat = 40.0
    
    public var trigger = true {
        didSet {
            if trigger {
                self.unTrigger()
            } else {
                self.traggered()
            }
        }
    }
    
    private var displayLink: CADisplayLink?
    private lazy var helperView: UIView = {
        let view = UIView(frame: CGRectMake(-self.helperWidth, 0, self.helperWidth, self.helperWidth))
        view.hidden = true
        return view
    }()
    private lazy var helperCenterView: UIView = {
        let view = UIView(frame: CGRectMake(-self.helperWidth, self.bounds.height, self.helperWidth, self.helperWidth))
        view.backgroundColor = yellowColor
        view.hidden = true
        return view
    }()
    
    private var diff: CGFloat = 0.0
    private var animationCount = 0.0
    
    init() {
        super.init(frame: CGRectZero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = clearColor
        self.frame = CGRectMake(-screenSize.width / 2 - maxOffset, 0, screenSize.width / 2 + maxOffset, screenSize.height)
        self.addSubview(self.helperView)
        self.addSubview(self.helperCenterView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 0))
        path.addLineToPoint(CGPointMake(screenSize.width / 2, 0))
        path.addQuadCurveToPoint(CGPointMake(screenSize.width / 2, screenSize.height), controlPoint: CGPointMake(screenSize.width / 2 + diff, screenSize.height / 2))
        path.addLineToPoint(CGPointMake(0, screenSize.height))
        
        let context = UIGraphicsGetCurrentContext()
        CGContextAddPath(context, path.CGPath)
        menuColor.setFill()
        CGContextFillPath(context)
    }
    
    func displayLinkAction(displayLink: CADisplayLink) {
        guard let layer = self.helperView.layer.presentationLayer() as? CALayer else {
            return
        }
        guard let centerLayer = self.helperCenterView.layer.presentationLayer() as? CALayer else {
            return
        }
        
        let rect = layer.valueForKeyPath("frame")!.CGRectValue()
        let centerRect = centerLayer.valueForKeyPath("frame")!.CGRectValue()
        
        diff = rect.origin.x - centerRect.origin.x
        self.setNeedsDisplay()
    }
    
    private func traggered() {
        UIView.animateWithDuration(0.3) {
            self.frame = self.bounds
        }
        beforeAnimation()
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: [.AllowUserInteraction, .BeginFromCurrentState], animations: {
            self.helperView.center = CGPointMake(screenSize.width / 2, 0)
            }, completion: { finished in
              self.afterAnimation()
        })
        
        beforeAnimation()
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2.0, options: [.AllowUserInteraction, .BeginFromCurrentState], animations: {
            self.helperCenterView.center = CGPointMake(screenSize.width / 2, self.bounds.height / 2)
            }, completion: { finished in
                self.afterAnimation()
        })
    }
    
    private func unTrigger() {
        UIView.animateWithDuration(0.3) {
            self.frame = CGRectMake(-self.bounds.width - self.maxOffset, 0, self.bounds.width + self.maxOffset, self.bounds.height)
        }
        beforeAnimation()
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: [.AllowUserInteraction, .BeginFromCurrentState], animations: {
            self.helperView.center = CGPointMake(-self.maxOffset, 0)
            }, completion: { finished in
                self.afterAnimation()
        })
        
        beforeAnimation()
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: [.AllowUserInteraction, .BeginFromCurrentState], animations: {
            self.helperCenterView.center = CGPointMake(-self.helperWidth, self.bounds.height / 2)
            }, completion: { finished in
                self.afterAnimation()
        })
    }
    
    private func beforeAnimation() {
        if displayLink == nil {
            self.displayLink = CADisplayLink(target: self, selector: #selector(displayLinkAction))
            self.displayLink!.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        }
        self.animationCount += 1
    }
    
    private func afterAnimation() {
        self.animationCount -= 1
        if animationCount == 0 {
            self.displayLink?.invalidate()
            self.displayLink = nil
        }
    }
    
}
