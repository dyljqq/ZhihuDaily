//
//  StartImageView.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/23.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit
import SnapKit

class StartImageView: UIView {
    
    private lazy var startImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var backView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.blackColor()
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = whiteColor
        label.font = Font.font(size: 18)
        return label
    }()
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = textGrayColor
        label.font = Font.font(size: 15)
        return label
    }()
    
    private lazy var circleProgress: CircleProgressView = {
       let progress = CircleProgressView()
        progress.layer.borderColor = whiteColor.CGColor
        progress.layer.borderWidth = 1.0
        progress.layer.cornerRadius = cornerRadius
        progress.layer.masksToBounds = true
        progress.showBackgroundLayer = false
        return progress
    }()
    
    init () {
        super.init(frame: screenBounds)
        setup()
        setData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(startImageNotification(_:)), name: start_image_notification, object: nil)
        
        self.backgroundColor = blackColor
        
        self.addSubview(startImageView)
        self.addSubview(backView)
        self.backView.addSubview(circleProgress)
        self.backView.addSubview(titleLabel)
        self.backView.addSubview(contentLabel)
        
        startImageView.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }
        backView.snp_makeConstraints { make in
            make.left.right.equalTo(self)
            make.height.equalTo(100)
            make.bottom.equalTo(self).offset(100)
        }
        circleProgress.snp_makeConstraints { make in
            make.centerY.equalTo(self.backView)
            make.left.equalTo(self.backView).offset(leftSpace)
            make.width.height.equalTo(50)
        }
        titleLabel.snp_makeConstraints { make in
            make.bottom.equalTo(self.backView.snp_centerY)
            make.left.equalTo(self.circleProgress.snp_right).offset(10)
        }
        contentLabel.snp_makeConstraints { make in
            make.top.equalTo(self.backView.snp_centerY)
            make.left.equalTo(self.titleLabel)
        }
        UIView.animateWithDuration(2.5, animations: {
            self.backView.snp_updateConstraints { make in
                make.bottom.equalTo(self)
            }
        })
    }
    
    func startImageNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            print("Start image: no user info...")
            return
        }
        if let URLString = userInfo["startImageURL"] as? String {
            self.startImageView.kf_setImageWithURL(NSURL(string: URLString)!)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

extension StartImageView {
    // 初始化数据
    func setData() {
        titleLabel.text = "知乎日报"
        contentLabel.text = "每天三次，每次7分钟"
        circleProgress.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        circleProgress.setProgress(75, animated: true)
    }
}

