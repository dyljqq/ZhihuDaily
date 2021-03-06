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
    
    static let themes_url = prefix + "themes"
    
    // get the old news
    static func old_news_url(suffix: String)-> String {
        return prefix + "news/before/" + suffix
    }
    
    static func theme_detail_url(suffix: String)-> String {
        return prefix + "theme/" + suffix
    }
    
    static func news_content_url(newId: String)-> String {
        return prefix + "news/" + newId
    }
    
    static func news_long_comment(newId: String)-> String {
        return prefix + "story/" + newId + "/long-comments"
    }
    
    static func news_short_comment(newId: String)-> String {
        return prefix + "story/" + newId + "/short-comments"
    }
    
}