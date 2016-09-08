//
//  ParallaxHeaderView.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/26.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

@objc public protocol ParallaxHeaderViewDelegate {
    func stopScroll()
}

enum HeaderType {
    case Normal
    case Blur
    case WebView
}

public class ParallaxHeaderView: UIView {
    
    public var scrollView: UIScrollView!
    public weak var delegate: ParallaxHeaderViewDelegate?
    public var maxContentOffset: CGFloat = 154.0
    public var blurImageView: UIImageView?
    
    public var blurImage: UIImage = UIImage() {
        didSet {
            let image = self.blurImage.applyBlurWithRadius(5.0, tintColor: nil, saturationDeltaFactor: 1.0)
            self.blurImageView?.image = image
        }
    }
    
    class func parallaxHeader(subview subview: UIView, size: CGSize, type: HeaderType = .Normal)-> ParallaxHeaderView {
        let headerView = ParallaxHeaderView(frame: CGRectMake(0, 0, size.width, size.height))
        headerView.maxContentOffset = size.height
        subview.autoresizingMask = [.FlexibleBottomMargin, .FlexibleHeight, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleWidth]
        headerView.initialHeader(subview)
        switch type {
        case .Blur: headerView.initialHeaderWithBlurImageView(subview)
        case .WebView: headerView.frame = CGRectMake(0, -20, size.width, size.height)
        default: break
        }
        return headerView
    }
    
    func initialHeader(subview: UIView) {
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.addSubview(subview)
        self.addSubview(scrollView)
    }
    
    func initialHeaderWithBlurImageView(subview: UIView) {
        blurImageView = UIImageView(frame: subview.bounds)
        blurImageView?.autoresizingMask = [.FlexibleBottomMargin, .FlexibleHeight, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleWidth]
        blurImageView?.contentMode = .ScaleAspectFill
        blurImageView!.alpha = 1.0
        scrollView.addSubview(blurImageView!)
    }
    
    public func layoutView(offset offset: CGPoint) {
        let offsetY = offset.y
        if offsetY < -maxContentOffset {
            delegate?.stopScroll()
        } else if offsetY <= 0 && offsetY >= -maxContentOffset {
            var rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            rect.origin.y += offsetY
            rect.size.height -= offsetY
            scrollView.frame = rect
            scrollView.clipsToBounds = false
        }
    }
    
    public func layoutWithThemeView(offset offset: CGPoint) {
        let offsetY = offset.y
        var frame = scrollView.frame
        if offsetY > 0 {
            frame.origin.y = offsetY
            scrollView.frame = frame
            self.clipsToBounds = false
        } else if offsetY < -95 {
            self.delegate?.stopScroll()
        } else {
            var rect = self.bounds
            rect.origin.y += offsetY
            rect.size.height -= offsetY
            scrollView.frame = rect
            self.clipsToBounds = false
            blurImageView?.alpha = (offsetY + 95) / 95
        }
    }
    
}
