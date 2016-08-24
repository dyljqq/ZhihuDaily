//
//  BannerView.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/24.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class BannerView: UIView {
    
    private lazy var bannerImageView: UIImageView = {
       let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = whiteColor
        label.font = font(size: 18)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        self.bannerImageView.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }
        self.contentLabel.snp_makeConstraints { make in
            make.bottom.equalTo(-34)
            make.right.equalTo(self).offset(-leftSpace)
            make.left.equalTo(leftSpace)
        }
        super.updateConstraints()
    }
    
    private func setup() {
        self.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.addSubview(self.bannerImageView)
        self.addSubview(self.contentLabel)
    }
    
}

extension BannerView {
    
    func update(imageURL: String, content: String) {
        self.bannerImageView.setImageWithURL(NSURL(string: imageURL)!)
        self.contentLabel.text = content
    }
    
}
