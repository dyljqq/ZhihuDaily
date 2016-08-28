//
//  ParallaxHeaderView.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/26.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

public class ParallaxHeaderView: UIView {
    
    public var scrollView: UIScrollView!
    
    class func parallaxHeader(subview subview: UIView, size: CGSize)-> ParallaxHeaderView {
        let headerView = ParallaxHeaderView(frame: CGRectMake(0, 0, size.width, size.height))
        headerView.initialHeader(subview)
        return headerView
    }
    
    func initialHeader(subview: UIView) {
        scrollView = UIScrollView(frame: self.bounds)
        subview.autoresizingMask = [.FlexibleBottomMargin, .FlexibleHeight, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleWidth]
        scrollView.addSubview(subview)
        self.addSubview(scrollView)
    }
    
    public func layoutView(offset offset: CGPoint) {
        let offsetY = offset.y
        if offsetY < -154 {
            // TODO
        } else {
            var rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            rect.origin.y += offsetY
            rect.size.height -= offsetY
            scrollView.frame = rect
            scrollView.clipsToBounds = false
        }
    }
    
}
