//
//  DailyRequest.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/22.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation
import Elaine

typealias SuccessCallback = (value: [String: AnyObject])-> ()

class DailyRequest {
    
    static let sharedInstance: DailyRequest = {
        return DailyRequest()
    }()
    
    func getStartImage(callback: SuccessCallback) {
        Elaine.request(.GET, URLS.start_image_url).responseJSON { response in
            switch response.result {
            case .Success(let value):
                callback(value: value as! [String : AnyObject])
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func getNewStory(callback: SuccessCallback) {
        Elaine.request(.GET, URLS.new_story_url).responseJSON { response in
            switch response.result {
            case .Success(let value):
                callback(value: value as! [String : AnyObject])
            case .Failure(let error):
                print(error)
            }
        }
    }
    
}
