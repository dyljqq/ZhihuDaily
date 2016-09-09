//
//  CommentCell.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/9.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = fontColor
        label.font = Font.font(size: 15)
        return label
    }()
    
    lazy var praiseView: PraiseView = {
        let view = PraiseView()
        return view
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = textGrayColor
        label.font = Font.font(size: 12)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = textGrayColor
        label.font = Font.font(size: 12)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(comment: Comment) {
        self.avatarImageView.kf_setImageWithURL(NSURL(string: comment.avatar))
        self.authorLabel.text = comment.author
        self.praiseView.contentLabel.text = String(comment.likes)
        self.commentLabel.text = comment.content
        self.timeLabel.text = handleTime(comment.time)
    }
    
    private func setup() {
        contentView.addSubview(self.avatarImageView)
        contentView.addSubview(self.authorLabel)
        contentView.addSubview(self.praiseView)
        contentView.addSubview(self.commentLabel)
        contentView.addSubview(self.timeLabel)
        
        self.avatarImageView.snp_makeConstraints { make in
            make.left.top.equalTo(leftSpace)
            make.width.height.equalTo(20)
        }
        self.authorLabel.snp_makeConstraints { make in
            make.top.equalTo(self.avatarImageView)
            make.left.equalTo(self.avatarImageView.snp_right).offset(10)
        }
        self.praiseView.snp_makeConstraints { make in
            make.right.equalTo(self.contentView).offset(-leftSpace)
            make.centerY.equalTo(self.authorLabel)
            make.height.equalTo(15)
            make.width.equalTo(100)
        }
        self.commentLabel.snp_makeConstraints { make in
            make.top.equalTo(self.authorLabel.snp_bottom).offset(10)
            make.left.equalTo(self.authorLabel)
            make.right.equalTo(self.praiseView)
        }
        self.timeLabel.snp_makeConstraints { make in
            make.top.equalTo(self.commentLabel.snp_bottom).offset(15)
            make.left.equalTo(self.commentLabel)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
    }
    
}

extension CommentCell {
    
    func handleTime(time: Int64)-> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd hh:mm"
        
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(time))
        return formatter.stringFromDate(date)
    }
    
}
