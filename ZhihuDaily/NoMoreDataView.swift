//
//  NoMoreDataView.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/27.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class NoMoreDataView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "no_more_data")
        return imageView
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "暂无数据"
        label.textColor = textGrayColor
        label.font = Font.font(size: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addSubview(imageView)
        addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.snp_makeConstraints { make in
            make.bottom.equalTo(self.snp_centerY)
            make.centerX.equalToSuperview()
        }
        contentLabel.snp_makeConstraints { make in
            make.top.equalTo(self.snp_centerY).offset(5)
            make.centerX.equalToSuperview()
        }
    }
    
}
