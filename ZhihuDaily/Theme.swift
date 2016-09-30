//
//  Theme.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/30.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Theme {
    var thumbnail: String!
    var description: String!
    var id: Int!
    var name: String!
    
    mutating func convert(dic: [String: JSON]) {
        self.thumbnail = dic["thumbnail"]?.stringValue
        self.id = dic["id"]?.intValue
        self.description = dic["description"]?.stringValue
        self.name = dic["name"]?.stringValue
    }
}

struct Editor {
    var name: String!
    var avatar: String!
    var id: Int!
    var bio: String!
    var url: String!
    
    mutating func convert(dic: [String: JSON]) {
        self.bio = dic["bio"]?.stringValue
        self.id = dic["id"]?.intValue
        self.avatar = dic["avatar"]?.stringValue
        self.name = dic["name"]?.stringValue
        self.url = dic["url"]?.stringValue
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
    
    mutating func convert(dic: [String: JSON]) {
        let stories = dic["stories"]?.arrayValue
        for story in stories! {
            var model = Story()
            model.convert(story.dictionaryValue)
            self.stories.append(model)
        }
        let editors = dic["editors"]!.arrayValue
        for editor in editors {
            var model = Editor()
            model.convert(editor.dictionaryValue)
            self.editors.append(model)
        }
        self.description = dic["description"]?.stringValue
        self.background = dic["background"]?.stringValue
        self.name = dic["name"]?.stringValue
        self.image = dic["image"]?.stringValue
        self.image_source = dic["image_source"]?.stringValue
    }
}

class ThemeRequest {
    
    class func getThemes(callback: (datas: [Theme])-> ()) {
        DailyRequest.get(URLString: URLS.themes_url, successCallback: { value in
            
            let themes = value["others"].arrayValue
            
            var containers = [Theme]()
            for theme in themes {
                var model = Theme()
                model.convert(theme.dictionaryValue)
                containers.append(model)
            }
            callback(datas: containers)
        })
    }
    
    class func getThemeContent(id: Int, callback: (datas: ThemeContent)-> ()) {
        DailyRequest.get(URLString: URLS.theme_detail_url(String(id)), successCallback: { value in
            var themeContent = ThemeContent()
            themeContent.convert(value.dictionaryValue)
            callback(datas: themeContent)
        })
    }
    
}