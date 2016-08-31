//
//  DYLParallelView.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/24.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

@objc public protocol DYLParallelDelegate {
    // 移动选项卡
    func didMoveToItemAtIndex(index: Int)
    // 单击选项卡
    optional func didTapItemAtIndex(parallelView: DYLParallelView, index: Int)
}

@objc public protocol DYLParallelDatasource {
    // 选项卡视图
    func viewForItemAtIndex(parallelView: DYLParallelView, index: Int)-> UIView
    
    // 选项卡个数
    func numOfItemsInParallelView()-> Int
}

public class DYLParallelView: UIView {

    public weak var delegate: DYLParallelDelegate?
    public weak var datasource: DYLParallelDatasource? {
        didSet {
            reload()
        }
    }
    
    public var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex > self.datasource!.numOfItemsInParallelView() {
                selectedIndex = self.datasource!.numOfItemsInParallelView() - 1
            } else if selectedIndex < 0 {
                selectedIndex = 0
            }
            self.pageControl.currentPage = selectedIndex
            self.delegate?.didMoveToItemAtIndex(selectedIndex)
        }
    }
    
    public var showTimer = true {
        didSet {
            if showTimer {
                timer = NSTimer.scheduledTimerWithTimeInterval(timerDuration, target: self, selector: #selector(scrollBanners), userInfo: nil, repeats: true)
            } else {
                if timer.valid {
                    timer.invalidate()
                }
            }
        }
    }
    public var timer: NSTimer!
    public var total = 0
    public var currentIndex = 0
    public var timerDuration = 5.0
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        self.pageControl.center = CGPointMake(CGRectGetMidX(bounds), bounds.height - 17)
        self.pageControl.bounds = CGRectMake(0, 0, 100, 34)
    }
    
    private func setup() {
        assert(self.datasource == nil, "请实现DYLParallelDatasource")
        self.addSubview(self.scrollView)
        self.addSubview(self.pageControl)
        self.pageControl.center = CGPointMake(CGRectGetMidX(bounds), bounds.height - 17)
        self.pageControl.bounds = CGRectMake(0, 0, 100, 34)
        
        reload()
        showTimer = true
    }
    
    deinit {
        if timer.valid {
            timer.invalidate()
            timer = nil
        }
    }
    
    func scrollBanners() {
        guard total > 0 else {
            return
        }
        currentIndex = (currentIndex + 1) % total
        scrollView.contentOffset.x = CGFloat(currentIndex) * scrollView.bounds.width
        currentItem()
    }
    
    func reload() {
        guard let datasource = self.datasource else {
            return ;
        }
        
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        total = datasource.numOfItemsInParallelView()
        self.pageControl.numberOfPages = total
        for i in 0 ..< total {
            addItem(i)
        }
        self.scrollView.contentSize = CGSizeMake(CGFloat(total) * self.frame.width, self.frame.height)
    }
    
    private func addItem(index: Int) {
        let item = self.datasource!.viewForItemAtIndex(self, index: index)
        item.frame = CGRectMake(CGFloat(index) * screenSize.width, 0, bounds.width, bounds.height)
        item.autoresizingMask = [.FlexibleBottomMargin, .FlexibleHeight, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleWidth]
        scrollView.addSubview(item)
    }
    
}

extension DYLParallelView: UIScrollViewDelegate {
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            currentItem()
        }
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        currentItem()
    }
    
}

// Helper
extension DYLParallelView {
    
    private func currentItem() {
        let index = round(scrollView.contentOffset.x / scrollView.bounds.size.width)
        let xFinal = index * scrollView.bounds.size.width
        scrollView.setContentOffset(CGPoint(x: xFinal, y: 0), animated: true)
        pageControl.currentPage = Int(index)
        currentIndex = Int(index)
        self.delegate?.didMoveToItemAtIndex(Int(index))
    }
    
}
