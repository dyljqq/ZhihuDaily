//
//  Comment.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/9.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

struct Comment {
    var author: String!
    var id: String!
    var content: String!
    var likes: Int!
    var avatar: String!
    var time: Int64!
    
    mutating func convert(dic: [String: AnyObject]) {
        author = dic["author"] as? String ?? ""
        id = dic["id"] as? String ?? ""
        content = dic["content"] as? String ?? ""
        likes = dic["likes"] as? Int ?? 0
        time = (dic["time"] as? NSNumber)?.longLongValue
        avatar = dic["avatar"] as? String ?? ""
    }
}