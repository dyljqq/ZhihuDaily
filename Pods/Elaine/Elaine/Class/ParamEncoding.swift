//
//  Mehod.swift
//  Elaine
//
//  Created by 季勤强 on 16/7/25.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

public enum Method: String {
    case OPTIONS, GET, POST, PUT, DELETE
}

public enum ParamterEncoding {
    case URL
    case JSON
    
    public func encode(URLRequest: URLRequestConvertible,
                       paramters: [String: AnyObject]?)-> (NSMutableURLRequest, NSError?) {
        
        return (URLRequest.URLRequest, nil)
    }
    
}