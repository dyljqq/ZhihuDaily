//
//  DailyRequest.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/22.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias SuccessCallback = (value: JSON)-> ()
typealias FailureCallback = (error: NSError)-> ()

class DailyRequest {
    
    class func get(URLString URLString: String,
                            parameters: [[String: AnyObject]]? = nil,
                            successCallback: SuccessCallback,
                            failureCallback: FailureCallback? = nil) {
        print("URLString: \(URLString)\nparameters: \(parameters)")
        Alamofire.request(.GET, URLString).responseJSON { response in
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                print("response value: \(json)")
                successCallback(value: json)
            case .Failure(let error):
                print("Network error: \(error)")
                if let failureCallback = failureCallback {
                    failureCallback(error: error)
                }
            }
        }
    }
    
}
