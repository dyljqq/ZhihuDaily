//
//  Response.swift
//  Elaine
//
//  Created by 季勤强 on 16/7/26.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

public struct Response<Value, Error: ErrorType> {
    
    public let request: NSURLRequest?
    
    public let response: NSURLResponse?
    
    public let data: NSData?
    
    public let result: Result<Value, Error>
    
    public init(
        request: NSURLRequest?,
        response: NSURLResponse?,
        data: NSData?,
        result: Result<Value, Error>
        ) {
        self.request = request
        self.result = result
        self.response = response
        self.data = data
    }
    
}