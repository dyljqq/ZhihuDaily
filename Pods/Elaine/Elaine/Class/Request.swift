//
//  Request.swift
//  Elaine
//
//  Created by 季勤强 on 16/7/25.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

public class Request {
    
    public var task: NSURLSessionTask { return delegate.task }
    
    public var session: NSURLSession
    
    public var request: NSURLRequest? { return task.originalRequest }
    
    public var response: NSHTTPURLResponse?  { return task.response as? NSHTTPURLResponse }
    
    public let delegate: TaskDelegate
    
    init(session: NSURLSession, task: NSURLSessionTask) {
        self.session = session
        
        switch task {
        case is NSURLSessionUploadTask: delegate = TaskDelegate(task: task)
        case is NSURLSessionDataTask: delegate = DataTaskDelegate(task: task)
        case is NSURLSessionDownloadTask: delegate = TaskDelegate(task: task)
        default: delegate = TaskDelegate(task: task)
        }
    }
    
    public func resume() {
        task.resume()
    }
    
    // MARK: - DataDelegate
    
    public class TaskDelegate: NSObject {
        
        // The serial operation queue used to execute all operations after the task completes.
        public let queue: NSOperationQueue
        
        let progress: NSProgress
        
        let task: NSURLSessionTask
        
        var data: NSData? { return nil }
        var error: NSError?
        
        init(task: NSURLSessionTask) {
            self.task = task
            self.progress = NSProgress(totalUnitCount: 0)
            self.queue = {
                let operationQueue = NSOperationQueue()
                operationQueue.maxConcurrentOperationCount = 1
                operationQueue.suspended = true
                return operationQueue
            }()
        }
        
        deinit {
            queue.cancelAllOperations()
            queue.suspended = false
        }
        
        var taskDidCompleteWithError: ((NSURLSession, NSURLSessionTask, NSError?)-> Void)?
        
        public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
            if let taskDidCompleteWithError = taskDidCompleteWithError {
                taskDidCompleteWithError(session, task, error)
            } else {
                if let error = error {
                    self.error = error
                }
                
                queue.suspended = false
            }
        }
        
    }
    
    // MARK: - DataTaskDelegate
    
    public class DataTaskDelegate: TaskDelegate, NSURLSessionDataDelegate {
        
        var dataTask: NSURLSessionDataTask? { return task as? NSURLSessionDataTask }
        
        private var totalBytesReceived: Int64 = 0
        private var mutableData: NSMutableData
        override var data: NSData? {
            if dataStream != nil {
                return nil
            } else {
                return mutableData
            }
        }
        
        private var expectedContentLength: Int64?
        private var dataProgress: ((bytesReceived: Int64, totalBytesReceived: Int64, totalBytesExpectedToReceive: Int64) -> Void)?
        private var dataStream: ((data: NSData) -> Void)?
        
        override init(task: NSURLSessionTask) {
            mutableData = NSMutableData()
            super.init(task: task)
        }
        
        var dataTaskDidReceiveData: ((NSURLSession, NSURLSessionDataTask, NSData) -> Void)?
        
        public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
            
            if let dataTaskDidReceiveData = dataTaskDidReceiveData {
                dataTaskDidReceiveData(session, dataTask, data)
            } else {
                if let dataStream = dataStream {
                    dataStream(data: data)
                } else {
                    mutableData.appendData(data)
                }
                
                totalBytesReceived += data.length
                let totalBytesExpected = dataTask.response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown
                
                progress.totalUnitCount = totalBytesExpected
                progress.completedUnitCount = totalBytesReceived
                
                dataProgress?(
                    bytesReceived: Int64(data.length),
                    totalBytesReceived: totalBytesReceived,
                    totalBytesExpectedToReceive: totalBytesExpected
                )
            }
        }
        
    }
    
}