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
        label.font = Font.font(size: 18)
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
    
    override func layoutSubviews() {
        self.contentLabel.snp_makeConstraints { make in
            make.bottom.equalTo(-34)
            make.right.equalTo(self).offset(-leftSpace)
            make.left.equalTo(leftSpace)
        }
        super.layoutSubviews()
    }
    
    private func setup() {
        self.bannerImageView.frame = self.bounds
        self.addSubview(self.bannerImageView)
        gradientLayer()
        self.addSubview(self.contentLabel)
    }
    
}

extension BannerView {
    
    func update(imageURL: String, content: String) {
        self.bannerImageView.setImageWithURL(NSURL(string: imageURL)!)
        self.contentLabel.text = content
    }
    
    func gradientLayer() {
        
        // attention CGColor
        let color1 = RGB(0, green: 0, blue: 0, alpha: 0.7).CGColor
        let color2 = RGB(0, green: 0, blue: 0, alpha: 0.25).CGColor
        let color3 = RGB(0, green: 0, blue: 0, alpha: 0.15).CGColor
        let color4 = RGB(0, green: 0, blue: 0, alpha: 0.75).CGColor
        let colors = [color1, color2, color3, color4]

        let locations: [NSNumber] = [0, 0.2, 0.5, 1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.frame = self.bounds
        
        let gradientView = UIView(frame: self.bounds)
        gradientView.layer.insertSublayer(gradientLayer, atIndex: 0)
        self.addSubview(gradientView)
    }
    
}
