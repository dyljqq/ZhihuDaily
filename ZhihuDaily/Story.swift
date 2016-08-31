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
    var image: String! = ""
    var title: String!
    var type: Int!
    var images: [String]!
    
    mutating func convert(dic: [String: AnyObject]) {
        self.id = "\((dic["id"] as! NSNumber).intValue)"
        self.title = dic["title"] as! String
        self.type = dic["type"] as! Int
        
        if let image = dic["image"] as? String {
            self.image = image
        }
        
        if let images = dic["images"] as? [String] {
            self.images = images
            if self.image == "" {
                self.image = self.images.count > 0 ? self.images[0] : ""
            }
        }
    }
    
}

typealias StoriesComplete = (banners: [Story], stories: [Story], oldStories: [[Story]], dates: [String], scrollPoints: [ScrollPoint])-> ()

struct ScrollPoint {
    var start: Double = 0.0
    var end: Double = 0.0
}

class StoryRequest {
    
    private var banners = [Story]()
    private var stories = [Story]()
    private var oldStories = [[Story]]()
    private var dates = [String]()
    private var scrollPoints = [ScrollPoint]()
    
    private let dataQueue = dispatch_queue_create("com.dyljqq.zhihu.dataQueue", DISPATCH_QUEUE_SERIAL)
    private let semaphore = dispatch_semaphore_create(1)
    
    func getData(callback: StoriesComplete) {
        
        dispatch_async(self.dataQueue) {
            
            self.banners.removeAll()
            self.stories.removeAll()
            self.oldStories.removeAll()
            self.dates.removeAll()
            self.scrollPoints.removeAll()
            
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
            self.getNewStories {
                dispatch_semaphore_signal(self.semaphore)
            }
            
            for index in 0..<10 {
                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
                self.getOldStories(-(index + 1)) {
                    dispatch_semaphore_signal(self.semaphore)
                }
            }
            
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
            dispatch_async(dispatch_get_main_queue()) {
                callback(banners: self.banners, stories: self.stories, oldStories: self.oldStories, dates: self.dates, scrollPoints: self.scrollPoints)
            }
            dispatch_semaphore_signal(self.semaphore)
            
        }
        
    }
    
    func getNewStories(callback: ()-> ()) {
        // get new story
        DailyRequest.get(URLString: URLS.new_story_url, successCallback: { value in
            guard let topStories = value["top_stories"] as? [[String: AnyObject]] else {
                print("no top_stories")
                return
            }
            guard let stories = value["stories"] as? [[String : AnyObject]] else {
                print("no stories")
                return
            }
            self.banners = self.convertStory(topStories)
            self.stories = self.convertStory(stories)
            self.scrollPoints.append(ScrollPoint(start: 120, end: 120 + 93 * Double(self.stories.count)))
            callback()
        })
    }
    
    func getOldStories(diff: Int, callback: ()-> ()) {
        DailyRequest.get(URLString: URLS.old_news_url(diff.days.fromNow.format(format: "yyyyMMdd")), successCallback: { value in
            guard let stories = value["stories"] as? [[String : AnyObject]] else {
                print("no old story in \((-1).days.fromNow.format(format: "yyyyMMdd"))")
                return ;
            }
            
            let oldStories = self.convertStory(stories)
            self.oldStories.append(oldStories)
            
            let dateString = value["date"] as! String
            self.dates.append(dateString.dateString("yyyyMMdd"))
            
            let start = self.scrollPoints[abs(diff) - 1].end
            let end = start + 93 * Double(oldStories.count) + 30
            self.scrollPoints.append(ScrollPoint(start: start, end: end))
            callback()
            }, failureCallback: { error in
                callback()
        })
    }
    
    func convertStory(stories: [[String: AnyObject]])-> [Story] {
        var containers = [Story]()
        for story in stories {
            var model = Story()
            model.convert(story)
            containers.append(model)
        }
        return containers
    }
    
}