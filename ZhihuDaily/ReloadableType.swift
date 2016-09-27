//
//  ReloadType.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/27.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

protocol ReloadableType {
    func dj_reloadData()
}

extension UIView: ReloadableType {
    func dj_reloadData() {
        for subview in subviews {
            if let subview = subview as? UITableView  {
                subview.reloadData()
                break
            }
        }
    }
}