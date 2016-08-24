//
//  Result.swift
//  Elaine
//
//  Created by 季勤强 on 16/7/26.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

public enum Result<Value, Error: ErrorType> {
    case Success(Value)
    case Failure(Error)
    
    public var isSuccess: Bool {
        switch self {
        case .Success:
            return true
        case .Failure:
            return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var value: Value? {
        switch self {
        case .Success(let Value):
            return Value
        default:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .Success:
            return nil
        case .Failure(let error):
            return error
        }
    }
    
}