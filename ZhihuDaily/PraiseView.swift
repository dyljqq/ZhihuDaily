//
//  PraiseView.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/9.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class PraiseView: UIView {

    lazy var praiseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heart_unselected")
        return imageView
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = textGrayColor
        label.font = Font.font(size: 9)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = clearColor
        
        addSubview(self.praiseImageView)
        addSubview(contentLabel)
        
        self.praiseImageView.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self.contentLabel.snp_left).offset(-5)
            make.width.height.equalTo(10)
        }
        self.contentLabel.snp_makeConstraints { make in
            make.right.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
    
}
