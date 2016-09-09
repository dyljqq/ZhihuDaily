//
//  FooterBar.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/8.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class FooterBar: UIView {
    
    var total: CGFloat = 5.0
    
    var callback: (index: Int)-> () = {_ in }
    
    private lazy var line: UIView = {
        let line = UIView(frame: CGRectMake(0, 0, screenSize.width, 0.5))
        line.backgroundColor = lineColor
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = whiteColor
        addSubview(self.line)
        
        let icons = ["left_back", "left_back", "heart_unselected", "share", "comment"]
        for index in 0..<icons.count {
            addIcon(icons[index], index: index)
        }
    }
    
    private func addIcon(name: String, index: Int) {
        let x = CGFloat(index) * screenSize.width / total
        let width = screenSize.width / total
        let imageView = UIImageView()
        imageView.image = UIImage(named: name)
        imageView.contentMode = .ScaleAspectFit
        imageView.tag = 8888 + index
        self.addSubview(imageView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(iconTapped(_:)))
        imageView.addGestureRecognizer(gesture)
        imageView.userInteractionEnabled = true
        
        if index == 1 {
            imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2) * 3)
        }
        
        imageView.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.width.height.equalTo(20)
            make.left.equalTo(x + width / 2 - 10)
        }
    }
    
    func iconTapped(gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else {
            return
        }
        let tag = view.tag - 8888
        callback(index: tag)
    }
    
}
