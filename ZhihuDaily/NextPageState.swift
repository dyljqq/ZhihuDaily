//
//  NextPageState.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/27.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

struct NextPageSate<T> {
    
    private(set) var hasNext: Bool
    private(set) var isLoading: Bool
    private(set) var lastId: T?
    
    init() {
        hasNext = true
        isLoading = false
        lastId = nil
    }
    
    mutating func reset() {
        hasNext = true
        isLoading = false
        lastId = nil
    }
    
    mutating func update(hasNext: Bool, isLoading: Bool) {
        self.hasNext = hasNext
        self.isLoading = isLoading
    }
    
}