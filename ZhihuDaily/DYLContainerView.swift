//
//  DYLContainerView.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/26.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class DYLContainerView: UIView {
    
    private var item = UIView()
    
    private var containerView = UIView()
    
    private var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.setImageWithURL(NSURL(string: "http://pic4.zhimg.com/6871284b987f2fea8d1cc05b2e7ea33b.jpg")!)
        item.addSubview(imageView)
        
        containerView.backgroundColor = blackColor
        self.addSubview(containerView)
        item.backgroundColor = UIColor.redColor()
        item.translatesAutoresizingMaskIntoConstraints = true
        containerView.addSubview(item)
        containerView.snp_makeConstraints { make in
            make.left.width.equalTo(self)
            make.top.equalTo(0)
            make.height.equalTo(bounds.height)
        }
        item.snp_makeConstraints { make in
            make.edges.equalTo(containerView)
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    func layoutView(offset offset: CGPoint) {
        let offsetY = offset.y
        if offsetY < -154 {
            // TODO
        } else {
            var rect = bounds;
//            rect.origin.y += offsetY
//            rect.size.height -= offsetY
//            containerView.frame = rect
            containerView.snp_updateConstraints { make in
                make.top.equalTo(rect.origin.y + offsetY)
                make.height.equalTo(rect.size.height + offsetY)
            }
            item.snp_makeConstraints { make in
                make.edges.equalTo(containerView)
            }
            setNeedsUpdateConstraints()
            print("item.frame: \(item.frame)")
            print("containerView: \(containerView.frame)")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
