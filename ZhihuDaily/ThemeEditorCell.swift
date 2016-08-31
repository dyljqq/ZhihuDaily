//
//  EditorCell.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/31.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class ThemeEditorCell: UITableViewCell {

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "主编"
        label.textColor = fontColor
        label.font = Font.font(size: 12)
        return label
    }()
    
    var editors = [Editor]() {
        didSet {
            setEditorImage()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEditorImage() {
        var temp: UIImageView? = nil
        for (index, editor) in editors.enumerate() {
            var avatarImageView = self.viewWithTag(index + 8888) as? UIImageView
            if avatarImageView == nil {
                avatarImageView = UIImageView()
                avatarImageView!.tag = index + 8888
                avatarImageView?.layer.cornerRadius = 7.5
                avatarImageView?.layer.masksToBounds = true
                self.contentView.addSubview(avatarImageView!)
                avatarImageView!.snp_makeConstraints { make in
                    if let iv = temp {
                        make.left.equalTo(iv.snp_right).offset(10)
                    } else {
                        make.left.equalTo(label.snp_right).offset(10)
                    }
                    make.width.height.equalTo(15)
                    make.centerY.equalTo(self.contentView)
                }
            }
            avatarImageView!.kf_setImageWithURL(NSURL(string: editor.avatar))
            temp = avatarImageView
        }
    }
    
    private func setup() {
        self.contentView.addSubview(self.label)
        
        self.label.snp_makeConstraints { make in
            make.left.equalTo(leftSpace)
            make.centerY.equalTo(self.contentView)
        }
    }
    
}
