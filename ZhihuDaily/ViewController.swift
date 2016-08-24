//
//  ViewController.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/22.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit
import Dyljqq

class ViewController: UIViewController {
    
    private var lauchImageView: StartImageView? = StartImageView()
    private var topBanner: DYLParallelView = DYLParallelView(frame: CGRectMake(0, 0, 375, 200))
    private var banners = [Story]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = whiteColor
        setup()
    }
    
    func setup() {
        self.view.addSubview(self.topBanner)
        self.topBanner.hidden = true
        self.topBanner.delegate = self
        self.topBanner.datasource = self
        self.topBanner.selectedIndex = 0
        guard let lauchImageView = self.lauchImageView else {
            return
        }
        self.view.addSubview(lauchImageView)
        lauchImageView.alpha = 0.9
        lauchImageView.snp_makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        UIView.animateWithDuration(2.5, animations: {
            lauchImageView.alpha = 1.0
        }, completion: { stop in
            UIView.animateWithDuration(0.2, animations: {
                lauchImageView.alpha = 0.0
            }) { finished in
                lauchImageView.removeFromSuperview()
                self.topBanner.hidden = false
            }
        })
        getData()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    
    func getData() {
        
        DailyRequest.sharedInstance.getNewStory { value in
            guard let stories = value["top_stories"] as? [[String: AnyObject]] else {
                return
            }
            for story in stories {
                var model = Story()
                model.convert(story)
                self.banners.append(model)
            }
            self.topBanner.reload()
        }
    }
    
}

extension ViewController: DYLParallelDelegate {
    func didMoveToItemAtIndex(index: Int) {
        print("move: \(index)")
    }
    
    func didTapItemAtIndex(parallelView: DYLParallelView, index: Int) {
        print("tap: \(index)")
    }
}

extension ViewController: DYLParallelDatasource {
    
    func viewForItemAtIndex(parallelView: DYLParallelView, index: Int) -> UIView {
        let bannerView = BannerView(frame: CGRectMake(0, 0, screenSize.width, 150))
        let imageURL = banners[index].image
        bannerView.update(imageURL!, content: banners[index].title)
        return bannerView
    }
    
    func numOfItemsInParallelView() -> Int {
        return banners.count
    }
    
}


