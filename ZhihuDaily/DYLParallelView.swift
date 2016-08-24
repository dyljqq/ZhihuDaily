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
    
    private func setup() {
        assert(self.datasource == nil, "请实现DYLParallelDatasource")
        
        self.addSubview(self.scrollView)
        self.addSubview(self.pageControl)
        reload()
    }
    
    func reload() {
        guard let datasource = self.datasource else {
            return ;
        }
        let count = datasource.numOfItemsInParallelView()
        self.pageControl.numberOfPages = count
        self.pageControl.center = CGPoint(x: CGRectGetMidX(self.scrollView.frame), y: self.scrollView.frame.size.height - 17)
        self.pageControl.bounds = CGRectMake(0, 0, 100, 34)
        for i in 0 ..< count {
            addItem(i)
        }
        self.scrollView.contentSize = CGSizeMake(CGFloat(count) * self.frame.width, self.frame.height)
        layoutIfNeeded()
    }
    
    private func addItem(index: Int) {
        let item = self.datasource!.viewForItemAtIndex(self, index: index)
        item.frame = CGRectMake(CGFloat(index) * screenSize.width, 0, frame.size.width, frame.size.height)
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
        self.delegate?.didMoveToItemAtIndex(Int(index))
    }
    
}
