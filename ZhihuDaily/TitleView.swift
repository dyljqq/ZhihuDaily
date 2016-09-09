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
        label.font = Font.font(size: 18)
        return label
    }()
    
    lazy var circleView: CircleProgressView = {
        let view = CircleProgressView()
        view.layer.cornerRadius = 9
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
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.circleView)
        self.addSubview(self.activityView)
        
        self.titleLabel.snp_makeConstraints { make in
            make.center.equalTo(self)
        }
        self.circleView.snp_makeConstraints { make in
            make.right.equalTo(self.titleLabel.snp_left).offset(-5)
            make.centerY.equalTo(self)
            make.width.height.equalTo(18)
        }
        self.activityView.snp_makeConstraints { make in
            make.edges.equalTo(self.circleView)
        }
    }
    
}