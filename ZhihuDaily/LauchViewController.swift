//
//  LauchViewController.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/27.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class LauchViewController: UIViewController {
    
    private var lauchImageView: StartImageView? = StartImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let lauchImageView = self.lauchImageView else {
            return
        }
        self.view.addSubview(lauchImageView)
        lauchImageView.snp_makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        self.view.addSubview(lauchImageView)
        
    }
    
    
}
