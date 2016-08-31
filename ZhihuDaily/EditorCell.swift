//
//  EditorCell.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/31.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class EditorCell: UITableViewCell {
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = fontColor
        label.font = Font.font(size: 15)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
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
    
    func update(editor: Editor) {
        self.avatarImageView.kf_setImageWithURL(NSURL(string: editor.avatar))
        self.titleLabel.text = editor.name
        self.contentLabel.text = editor.bio
    }
    
    private func setup() {
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.contentLabel)
        
        self.avatarImageView.snp_makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(leftSpace)
            make.width.height.equalTo(40)
        }
        self.titleLabel.snp_makeConstraints { make in
            make.left.equalTo(self.avatarImageView.snp_right).offset(10)
            make.top.equalTo(self.avatarImageView)
        }
        self.contentLabel.snp_makeConstraints { make in
            make.left.equalTo(self.titleLabel)
            make.bottom.equalTo(self.avatarImageView)
        }
        
    }
    
}
