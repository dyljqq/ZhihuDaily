//
//  RefreshView.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/9.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

enum ArrowDirection {
    case Down
    case Up
}

class RefreshView: UIView {
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = whiteColor
        label.font = Font.font(size: 15)
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow")
        imageView.tintColor = whiteColor
        return imageView
    }()
    
    var direction: ArrowDirection = .Down {
        didSet {
            switch direction {
            case .Up: self.arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            default: self.arrowImageView.transform = CGAffineTransformIdentity
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = clearColor
        self.addSubview(self.contentLabel)
        self.addSubview(self.arrowImageView)
        
        self.contentLabel.snp_makeConstraints { make in
            make.center.equalTo(self)
        }
        self.arrowImageView.snp_makeConstraints { make in
            make.right.equalTo(self.contentLabel.snp_left).offset(-10)
            make.centerY.equalTo(self.contentLabel)
        }
    }
    
}
