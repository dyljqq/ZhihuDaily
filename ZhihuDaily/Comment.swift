//
//  Comment.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/9.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Comment {
    var author: String!
    var id: String!
    var content: String!
    var likes: Int!
    var avatar: String!
    var time: Int64!
    
    mutating func convert(dic: [String: JSON]) {
        author = dic["author"]?.stringValue
        id = dic["id"]?.stringValue
        content = dic["content"]?.stringValue
        likes = dic["likes"]?.intValue
        time = dic["time"]?.int64Value
        avatar = dic["avatar"]?.stringValue
    }
}