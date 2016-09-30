//
//  NextPageLoadable.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/27.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

/// 面向协议变成编程 加载UITableView数据
protocol NextPageLoadable: class {
    
    associatedtype DataType
    associatedtype LastIdType
    
    var data: [DataType] { get set }
    var nextPageState: NextPageState<LastIdType> { get set }
    
    func performLoad(successHandler: (rows: [DataType], hasNext: Bool, lastId: LastIdType?)-> (),
                     failHandler: ()-> ())
    
}

extension NextPageLoadable {
    
    func loadNext(view: ReloadableType) {
        guard nextPageState.hasNext else { return }
        if nextPageState.isLoading { return }
        nextPageState.update(nextPageState.hasNext, isLoading: true)
        
        performLoad({ items, hasNext, lastId in
            
            self.data += items
            self.nextPageState.update(hasNext, isLoading: false)
            view.dj_reloadData()
            
        }, failHandler: {
            // TODO
        })
        
    }
    
}

extension NextPageLoadable where Self: UITableViewController {
    
    func loadNext() {
        loadNext(tableView)
    }
    
}

extension NextPageLoadable where Self: UIViewController {
    func loadNext() {
        loadNext(view)
    }
    
}

