//
//  ThemeCell.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/30.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class ThemeCell: UITableViewCell {
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGB(136, green: 141, blue: 145)
        label.font = Font.font(size: 15)
        return label
    }()
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "plus")!.imageWithRenderingMode(.AlwaysTemplate)
        imageView.tintColor = RGB(66, green: 62, blue: 77)
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(theme: Theme) {
        self.contentLabel.text = theme.name
    }
    
    private func setup() {
        self.backgroundColor = menuBackgroundColor
        self.addSubview(self.contentLabel)
        self.addSubview(self.icon)
        
        let selectedView = UIView(frame: self.contentView.frame)
        selectedView.backgroundColor = RGB(12, green: 19, blue: 25)
        self.selectedBackgroundView = selectedView
        self.contentLabel.highlightedTextColor = whiteColor
        
        self.contentLabel.snp_makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(leftSpace)
        }
        self.icon.snp_makeConstraints { make in
            make.right.equalTo(-30)
            make.width.equalTo(22)
            make.height.equalTo(22)
            make.centerY.equalTo(self.contentView)
        }
    }
    
}
