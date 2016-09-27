//
//  OverlayPresentable.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/27.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import Foundation

protocol DJOverlayPresentable {
    associatedtype Overlay: UIView
    
    var overlay: Overlay { get }
}

extension DJOverlayPresentable where Self: UIViewController {
    
    func displayOverlay(show: Bool) {
        show ? view.addSubview(overlay) : overlay.removeFromSuperview()
    }
    
}