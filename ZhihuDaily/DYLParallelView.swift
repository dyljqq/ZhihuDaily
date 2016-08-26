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
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    
    private var containerView = UIView()
    
    private var items = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        assert(self.datasource == nil, "请实现DYLParallelDatasource")
        containerView.backgroundColor = UIColor.redColor()
//        self.addSubview(self.scrollView)
        self.addSubview(self.pageControl)
        self.addSubview(self.containerView)
        reload()
        
//        self.scrollView.snp_makeConstraints { make in
//            make.edges.equalTo(self)
//        }
        self.pageControl.snp_makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(0)
            make.height.equalTo(34)
            make.width.equalTo(100)
        }
        self.containerView.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }
        
    }
    
    func reload() {
        guard let datasource = self.datasource else {
            return ;
        }
        let count = datasource.numOfItemsInParallelView()
        self.pageControl.numberOfPages = count
        for i in 0 ..< count {
            addItem(i)
        }
        self.scrollView.contentSize = CGSizeMake(CGFloat(count) * self.frame.width, self.frame.height)
        layoutIfNeeded()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
    }
    
    public func layoutView(offset offset: CGPoint) {
        let offsetY = offset.y
        if offsetY < -154 {
            // TODO
        } else {
            var rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            rect.origin.y += offsetY
            rect.size.height -= offsetY
            containerView.frame = rect
            containerView.backgroundColor = UIColor.blueColor()
            layoutIfNeeded()
        }
    }
    
    private func addItem(index: Int) {
//        let item = self.datasource!.viewForItemAtIndex(self, index: index)
        let item = UIView()
        item.backgroundColor = UIColor.greenColor()
        items.append(item)
        containerView.addSubview(item)
        item.snp_makeConstraints { make in
            make.left.equalTo(CGFloat(index) * screenSize.width)
            make.top.width.bottom.equalTo(containerView)
        }
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
