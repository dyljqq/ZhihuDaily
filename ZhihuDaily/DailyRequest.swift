//
//  DailyRequest.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/22.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation
import Alamofire

typealias SuccessCallback = (value: [String: AnyObject])-> ()
typealias FailureCallback = (error: NSError)-> ()

class DailyRequest {
    
    var method: Alamofire.Method = .GET
    
    static let sharedInstance: DailyRequest = {
        return DailyRequest()
    }()
    
    func callback(URLString URLString: String,
                            parameters: [[String: AnyObject]]? = nil,
                            successCallback: SuccessCallback,
                            failureCallback: FailureCallback? = nil) {
        print("URLString: \(URLString)\nparameters: \(parameters)")
        Alamofire.request(method, URLString).responseJSON { response in
            switch response.result {
            case .Success(let value):
                print("response value: \(value)")
                successCallback(value: value as! [String : AnyObject])
            case .Failure(let error):
                print("Network error: \(error)")
                if let failureCallback = failureCallback {
                    failureCallback(error: error)
                }
            }
        }
    }
    
}
