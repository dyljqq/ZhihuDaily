//
//  Theme.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/30.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

struct Theme {
    var thumbnail: String!
    var description: String!
    var id: Int!
    var name: String!
    
    mutating func convert(dic: [String: AnyObject]) {
        if let thumbnail = dic["thumbnail"] {
            self.thumbnail = thumbnail as! String
        }
        self.thumbnail = dic["thumbnail"] as! String
        self.id = (dic["id"] as!NSNumber).integerValue ?? 0
        self.description = dic["description"] as! String
        self.name = dic["name"] as! String
    }
}

struct Editor {
    var name: String!
    var avatar: String!
    var id: Int!
    var bio: String!
    var url: String!
    
    mutating func convert(dic: [String: AnyObject]) {
        self.bio = dic["bio"] as? String ?? ""
        self.id = (dic["id"] as! NSNumber).integerValue ?? 0
        self.avatar = dic["avatar"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.url = dic["url"] as? String ?? ""
    }
}

struct ThemeContent {
    var stories = [Story]()
    var description: String!
    var background: String!
    var name: String!
    var image: String!
    var editors = [Editor]()
    var image_source: String!
    
    mutating func convert(dic: [String: AnyObject]) {
        if let stories = dic["stories"] as? [[String: AnyObject]] {
            for story in stories {
                var model = Story()
                model.convert(story)
                self.stories.append(model)
            }
        }
        if let editors = dic["editors"] as? [[String: AnyObject]] {
            for editor in editors {
                var model = Editor()
                model.convert(editor)
                self.editors.append(model)
            }
        }
        self.description = dic["description"] as! String
        self.background = dic["background"] as! String
        self.name = dic["name"] as! String
        self.image = dic["image"] as! String
        self.image_source = dic["image_source"] as! String
    }
}

class ThemeRequest {
    
    class func getThemes(callback: (datas: [Theme])-> ()) {
        DailyRequest.get(URLString: URLS.themes_url, successCallback: { value in
            guard let themes = value["others"] as? [[String: AnyObject]] else {
                print("no themes")
                return
            }
            var containers = [Theme]()
            for theme in themes {
                var model = Theme()
                model.convert(theme)
                containers.append(model)
            }
            callback(datas: containers)
        })
    }
    
    class func getThemeContent(id: Int, callback: (datas: ThemeContent)-> ()) {
        DailyRequest.get(URLString: URLS.theme_detail_url(String(id)), successCallback: { value in
            var themeContent = ThemeContent()
            themeContent.convert(value)
            callback(datas: themeContent)
        })
    }
    
}