//
//  RightTransition.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/8.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class RightTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    
    var presenting = true
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        container.addSubview(toView)
        if presenting {
            presentView(transitionContext, toView: toView)
        } else {
            dismiss(transitionContext)
        }
        
    }
    
    private func presentView(transitionContext: UIViewControllerContextTransitioning, toView: UIView) {
        toView.transform = CGAffineTransformMakeTranslation(screenSize.width, 0)
        UIView.animateWithDuration(duration, animations: {
            toView.transform = CGAffineTransformIdentity
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
    private func dismiss(transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        transitionContext.containerView()!.bringSubviewToFront(fromView)
        UIView.animateWithDuration(duration, animations: {
            fromView.transform = CGAffineTransformMakeTranslation(screenSize.width, 0)
            }, completion: { _ in
             transitionContext.completeTransition(true)
        })
    }
    
}
