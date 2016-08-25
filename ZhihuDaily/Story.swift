//
//  Story.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/24.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

struct Story {
    var id: String!
    var image: String!
    var title: String!
    var type: Int!
    var images: [String]!
    
    mutating func convert(dic: [String: AnyObject]) {
        self.id = "\(dic["id"])" ?? ""
        self.image = (dic["image"] ?? "") as! String
        self.title = (dic["title"] ?? "") as! String
        self.type = (dic["type"] ?? 0) as! Int
        self.images = dic["images"] as? Array ?? [String]()
        if self.image == "" {
            self.image = self.images.count > 0 ? self.images[0] : ""
        }
    }
}