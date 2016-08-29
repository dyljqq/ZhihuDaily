//
//  TitleView.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/29.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class TitleView: UIView {
    
    var progress = 0 {
        didSet {
            self.circleView.setProgress(progress, animated: true)
        }
    }
    
    var showActivityIndicatorView = false {
        didSet {
            self.activityView.hidden = !showActivityIndicatorView
        }
    }
    
    var showCircleView = false {
        didSet {
            self.circleView.hidden = !showCircleView
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = whiteColor
        label.font = Font.font(size: 14)
        return label
    }()
    
    lazy var circleView: CircleProgressView = {
        let view = CircleProgressView()
        view.layer.cornerRadius = 7.5
        view.layer.masksToBounds = true
        view.showBackgroundLayer = true
        view.lineWidth = 1
        view.inset = 0
        return view
    }()
    
    lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityView.hidden = true
        return activityView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        self.activityView.hidden = true
        self.backgroundColor = clearColor
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.circleView)
        self.addSubview(self.activityView)
        
        self.circleView.frame = CGRectMake(5, 5, 15, 15)
        self.titleLabel.frame = CGRectMake(25, 5, 100, 15)
        self.activityView.frame = self.circleView.frame
    }
    
}