//
//  ResponseSerialization.swift
//  Elaine
//
//  Created by 季勤强 on 16/7/25.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

public protocol ResponseSerializerType {
    
    associatedtype SerializedObject
    
    associatedtype ErrorObject: ErrorType
    
    var serializeResponse: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Result<SerializedObject, ErrorObject> { get }
    
}

public struct ResponseSerializer<Value, Error: ErrorType>: ResponseSerializerType {
    
    public typealias SerializedObject = Value
    
    public typealias ErrorObject = Error
    
    public var serializeResponse: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Result<Value, Error>
    
    public init(serializeResponse: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Result<Value, Error>) {
        self.serializeResponse = serializeResponse
    }
    
}

extension Request {
    
    public func response(
        queue queue: dispatch_queue_t? = nil,
              completionHandler: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?)-> Void)-> Self {
        delegate.queue.addOperationWithBlock {
            dispatch_async(queue ??  dispatch_get_main_queue()) {
                completionHandler(self.request, self.response, self.delegate.data, self.delegate.error)
            }
        }
        return self
    }
    
    public func response<T: ResponseSerializerType>(
        queue queue: dispatch_queue_t? = nil,
              responseSerializer: T,
              completionHandler: Response<T.SerializedObject, T.ErrorObject> -> Void)
        -> Self
    {
        delegate.queue.addOperationWithBlock {
            let result = responseSerializer.serializeResponse(
                self.request,
                self.response,
                self.delegate.data,
                self.delegate.error
            )
            
            let response = Response<T.SerializedObject, T.ErrorObject>(
                request: self.request,
                response: self.response,
                data: self.delegate.data,
                result: result
            )
            
            dispatch_async(queue ?? dispatch_get_main_queue()) { completionHandler(response) }
        }
        
        return self
    }
    
}

extension Request {
    public static func dataResponseSerializer()-> ResponseSerializer<NSData, NSError> {
        return ResponseSerializer { _, response, data, error in
            guard error == nil else {
                return .Failure(error!)
            }
            
            if let response = response where response.statusCode == 204 { return .Success(NSData()) }
            
            guard let validData = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Error.error(code: .DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            return .Success(validData)
        }
    }
    
    public func responseData(
        queue queue: dispatch_queue_t? = nil,
              completionHandler: Response<NSData, NSError> -> Void)-> Self {
        return response(queue: queue, responseSerializer: Request.dataResponseSerializer(), completionHandler: completionHandler)
    }
}


extension Request {
    
    public static func JSONResponseSerializer(
        options options: NSJSONReadingOptions = .AllowFragments)
        -> ResponseSerializer<AnyObject, NSError>
    {
        return ResponseSerializer { _, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            if let response = response where response.statusCode == 204 { return .Success(NSNull()) }
            
            guard let validData = data where validData.length > 0 else {
                let failureReason = "JSON could not be serialized. Input data was nil or zero length."
                let error = Error.error(code: .JSONSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(validData, options: options)
                return .Success(JSON)
            } catch {
                return .Failure(error as NSError)
            }
        }
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter options:           The JSON serialization reading options. `.AllowFragments` by default.
     - parameter completionHandler: A closure to be executed once the request has finished.
     
     - returns: The request.
     */
    public func responseJSON(
        queue queue: dispatch_queue_t? = nil,
              options: NSJSONReadingOptions = .AllowFragments,
              completionHandler: Response<AnyObject, NSError> -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: Request.JSONResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
    
}

