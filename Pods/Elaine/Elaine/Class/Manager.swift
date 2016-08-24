//
//  Manager.swift
//  Elaine
//
//  Created by 季勤强 on 16/7/25.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

public class Manager {
    
    public static let sharedInstance: Manager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        return Manager(configuration: configuration)
        
    }()
    
    public static let defaultHTTPHeaders: [String: String] = {
        return [:]
    }()
    
    public var session: NSURLSession
    
    public var delegate: SessionDelegate
    
    let queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)
    
    init(configuration: NSURLSessionConfiguration,
         delegate: SessionDelegate = SessionDelegate()) {
        
        self.session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: delegate, delegateQueue: nil)
        self.delegate = delegate
        
    }
    
    // MARK: Request Method
    
    func request(
        method: Method,
        _ URLString: URLStringConvertible,
          parameters: [String: AnyObject]? = nil,
          encoding: ParamterEncoding = .URL,
          headers: [String: String]? = nil)-> Request{
        
        let mutableURLRequest = URLRequest(method, URLString, headers: headers)
        let encodingURLRequest = encoding.encode(mutableURLRequest, paramters: parameters).0
        return request(encodingURLRequest)
    }
    
    func request(URLRequest: URLRequestConvertible) -> Request {
        var dataTask: NSURLSessionDataTask!
        dispatch_sync(queue) { dataTask = self.session.dataTaskWithRequest(URLRequest.URLRequest) }
        let request = Request(session: session, task: dataTask)
        delegate[request.delegate.task] = request.delegate
        request.resume()
        return request
    }
    
   
    public class SessionDelegate: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate, NSURLSessionDataDelegate {
        
        private var subDelegates: [Int: Request.TaskDelegate] = [:]
        private let subDelegateQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)
        
        public subscript(task: NSURLSessionTask)-> Request.TaskDelegate? {
            get {
                var subDelegate: Request.TaskDelegate?
                dispatch_sync(subDelegateQueue) { subDelegate = self.subDelegates[task.taskIdentifier] }
                return subDelegate
            }
            set {
                dispatch_barrier_async(subDelegateQueue) { self.subDelegates[task.taskIdentifier] =  newValue }
            }
            
        }
        
        public var taskDidComplete: ((NSURLSession, NSURLSessionTask, NSError?) -> Void)?
        
        public var dataTaskDidReceiveData: ((NSURLSession, NSURLSessionDataTask, NSData) -> Void)?
        
        public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
            if let dataTaskDidReceiveData = dataTaskDidReceiveData {
                dataTaskDidReceiveData(session, dataTask, data)
            } else if let delegate = self[dataTask] as? Request.DataTaskDelegate {
                delegate.URLSession(session, dataTask: dataTask, didReceiveData: data)
            }
        }
        
        public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
            
        }
        
        public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
            if let taskDidComplete = taskDidComplete {
                taskDidComplete(session, task, error)
            } else if let delegate = self[task] {
                delegate.URLSession(session, task: task, didCompleteWithError: error)
            } else {
                print("error: \(error)")
            }
            
            self[task] = nil
        }
        
    }
    
}
