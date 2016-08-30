//
//  StoryCell.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/25.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

public class StoryCell: UITableViewCell {
    
    private lazy var contentLabel: UILabel = {
        var label = UILabel()
        label.textColor = fontColor
        label.font = Font.font(size: 15)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    private lazy var detailImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        self.contentLabel.snp_makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(leftSpace)
            make.right.equalTo(self.detailImageView.snp_left).offset(-10)
        }
        self.detailImageView.snp_makeConstraints {make in
            make.height.equalTo(60)
            make.width.equalTo(75)
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-leftSpace)
        }
        super.layoutSubviews()
    }
    
    private func setup() {
        self.contentView.backgroundColor = whiteColor
        self.contentView.addSubview(self.contentLabel)
        self.contentView.addSubview(self.detailImageView)
        layoutIfNeeded()
    }
    
}

extension StoryCell {
    func updateStory(story: Story) {
        self.contentLabel.text = story.title
        self.detailImageView.kf_setImageWithURL(NSURL(string: story.image)!)
    }
}
