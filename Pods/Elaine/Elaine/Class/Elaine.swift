//
//  Elaine.swift
//  Elaine
//
//  Created by 季勤强 on 16/7/25.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation


// MARK: - URLStringConvertible
public protocol URLStringConvertible {
    
    // A URL that conforms to RFC 2369
    // RFC: Request for comments
    var URLString: String {get}
    
}

extension String: URLStringConvertible {
    public var URLString: String {
        return self
    }
}

extension NSURL: URLStringConvertible {
    public var URLString: String {
        return absoluteString
    }
}

extension NSURLComponents: URLStringConvertible {
    public var URLString: String {
        return URL!.URLString
    }
}

// MARK: - URLRequestConvertible
public protocol URLRequestConvertible {
    var URLRequest: NSMutableURLRequest {get}
}

extension NSURLRequest: URLRequestConvertible {
    public var URLRequest: NSMutableURLRequest {
        return self.mutableCopy() as! NSMutableURLRequest
    }
}

// MARK: Convenience

func URLRequest(method: Method,
                _ URLString: URLStringConvertible,
                  headers: [String: String]? = nil)-> NSMutableURLRequest {
    let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: URLString.URLString)!)
    mutableURLRequest.HTTPMethod = method.rawValue
    
    if let headers = headers {
        for (headerField, headerValue) in headers {
            mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
        }
    }
    
    return mutableURLRequest
}

// MARK: - Request Method

public func request(method: Method,
             _ URLString: URLStringConvertible,
             params: [String: AnyObject]? = nil,
             encoding: ParamterEncoding = .URL,
             headers: [String: String]? = nil)-> Request {
    return Manager.sharedInstance.request(method, URLString, parameters: params, encoding: encoding, headers: headers)
}

