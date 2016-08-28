//
//  URLS.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/22.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

private let prefix = "http://news-at.zhihu.com/api/4/"

struct URLS {
    static let start_image_url = prefix + "start-image/\(Int(resolutionRate.width))*\(Int(resolutionRate.height))"
    static let new_story_url = prefix + "news/latest"
    
    // get the old news
    static func old_news_url(suffix: String)-> String {
        return prefix + "news/before/" + suffix
    }
}