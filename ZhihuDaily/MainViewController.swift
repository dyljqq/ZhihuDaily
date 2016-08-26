//
//  ViewController.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/22.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    struct Constant {
        static let reuseIdentifier = "StoryCell"
    }
    
    private var lauchViewController: LauchViewController = LauchViewController()
    private lazy var topBanner: DYLParallelView = {
        let topBanner = DYLParallelView(frame: CGRectMake(0, 0, 375, 154))
        topBanner.delegate = self
        topBanner.datasource = self
        topBanner.selectedIndex = 0
        topBanner.clipsToBounds = false
        topBanner.backgroundColor = whiteColor
        topBanner.autoresizesSubviews = true
        return topBanner
    }()
    private var banners = [Story]()
    private var stories = [Story]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, -navigationBarHeight, screenSize.width, screenSize.height + navigationBarHeight))
        tableView.backgroundColor = whiteColor
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(StoryCell.self, forCellReuseIdentifier: Constant.reuseIdentifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = whiteColor
        setup()
    }
    
    func setup() {
        self.navigationItem.titleView?.hidden = true
        
        // delete the bottom line
        for subview in (self.navigationController?.navigationBar.subviews)! {
            if subview.isKindOfClass(UIImageView.self) {
                subview.hidden = true
            }
        }
        
        self.view.addSubview(self.tableView)
        
        let headerView = ParallaxHeaderView.parallaxHeader(subview: self.topBanner, size: CGSizeMake(375, 154))
        self.tableView.tableHeaderView = headerView
        
        let lauchImageView = lauchViewController.view
        lauchImageView.alpha = 0.99
        self.addChildViewController(lauchViewController)
        self.view.addSubview(lauchImageView)
        UIView.animateWithDuration(2.5, animations: {
            lauchImageView.alpha = 1.0
        }, completion: { stop in
            UIView.animateWithDuration(0.2, animations: {
                self.setNavigation()
                lauchImageView.alpha = 0.0
            }) { finished in
                lauchImageView.removeFromSuperview()
            }
        })
        
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension MainViewController {
    
    func setNavigation() {
        self.title = "今日热闻"
        self.navigationItem.titleView?.hidden = false
        self.navigationController?.navigationBar.dyl_setBackgroundColor(clearColor)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let left = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(showMenu))
        left.tintColor = whiteColor
        navigationItem.setLeftBarButtonItem(left, animated: true)
    }
    
    func showMenu() {
        // TODO
    }
    
    func getData() {
        DailyRequest.sharedInstance.getNewStory { value in
            print(value)
            guard let topStories = value["top_stories"] as? [[String: AnyObject]] else {
                return
            }
            guard let stories = value["stories"] else {
                return
            }
            self.banners = self.convertStory(topStories)
            self.topBanner.reload()
            self.stories = self.convertStory(stories as! [[String : AnyObject]])
            self.tableView.reloadData()
        }
    }
    
    private func convertStory(stories: [[String: AnyObject]])-> [Story] {
        var containers = [Story]()
        for story in stories {
            var model = Story()
            model.convert(story)
            containers.append(model)
        }
        return containers
    }
}

extension MainViewController: DYLParallelDelegate {
    func didMoveToItemAtIndex(index: Int) {
        print("move: \(index)")
    }
    
    func didTapItemAtIndex(parallelView: DYLParallelView, index: Int) {
        print("tap: \(index)")
    }
}

extension MainViewController: DYLParallelDatasource {
    
    func viewForItemAtIndex(parallelView: DYLParallelView, index: Int) -> UIView {
        let bannerView = BannerView(frame: CGRectMake(0, 0, screenSize.width, 154))
        let imageURL = banners[index].image
        bannerView.update(imageURL!, content: banners[index].title)
        return bannerView
    }
    
    func numOfItemsInParallelView() -> Int {
        return banners.count
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // TODO
    }
    
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constant.reuseIdentifier, forIndexPath: indexPath) as! StoryCell
        cell.updateStory(stories[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.fd_heightForCellWithIdentifier(Constant.reuseIdentifier) { cell in
            (cell as! StoryCell).updateStory(self.stories[indexPath.row])
        }
    }
    
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let MAX: CGFloat = 90.0
        let header = self.tableView.tableHeaderView as! ParallaxHeaderView
        header.layoutView(offset: scrollView.contentOffset)
        // up
        if offsetY >= -navigationBarHeight {
            let alpha = min(1, (navigationBarHeight + offsetY)/(navigationBarHeight + MAX))
            self.navigationController?.navigationBar.dyl_setBackgroundColor(navigationColor.colorWithAlphaComponent(alpha))
        } else {
            // down
        }
    }
    
}


