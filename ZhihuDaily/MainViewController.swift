//
//  ViewController.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/22.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

struct ScrollPoint {
    var start: Double = 0.0
    var end: Double = 0.0
}

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
    private var oldStories = [[Story]]()
    private var dates = [String]()
    private var scrollPoints = [ScrollPoint]()
    
    private let dataQueue = dispatch_queue_create("com.dyljqq.zhihu.dataQueue", DISPATCH_QUEUE_SERIAL)
    private let semaphore = dispatch_semaphore_create(1)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height), style: .Grouped)
        tableView.backgroundColor = whiteColor
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(StoryCell.self, forCellReuseIdentifier: Constant.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.hidden = true
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
        headerView.delegate = self
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
                self.tableView.hidden = false
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
        
        dispatch_async(self.dataQueue) {
            
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
            self.getNewStories {
                dispatch_semaphore_signal(self.semaphore)
            }
            
            for index in 0..<10 {
                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
                self.getOldStories(-(index + 1)) {
                    dispatch_semaphore_signal(self.semaphore)
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func getNewStories(callback: ()-> ()) {
        // get new story
        DailyRequest.sharedInstance.callback(URLString: URLS.new_story_url, successCallback: { value in
            guard let topStories = value["top_stories"] as? [[String: AnyObject]] else {
                return
            }
            guard let stories = value["stories"] as? [[String : AnyObject]] else {
                return
            }
            self.banners = self.convertStory(topStories)
            self.topBanner.reload()
            
            self.stories = self.convertStory(stories)
            
            self.scrollPoints.append(ScrollPoint(start: 120, end: 120 + 93 * Double(self.stories.count)))
            
            callback()
        })
    }
    
    func getOldStories(diff: Int, callback: ()-> ()) {
        DailyRequest.sharedInstance.callback(URLString: URLS.old_news_url(diff.days.fromNow.format(format: "yyyyMMdd")), successCallback: { value in
            guard let stories = value["stories"] as? [[String : AnyObject]] else {
                print("no old story in \((-1).days.fromNow.format(format: "yyyyMMdd"))")
                return ;
            }
            let oldStories = self.convertStory(stories)
            self.oldStories.append(oldStories)
            
            let dateString = value["date"] as! String
            self.dates.append(dateString.dateString("yyyyMMdd"))
            
            let start = self.scrollPoints[abs(diff) - 1].end
            let end = start + 93 * Double(self.oldStories.count)
            self.scrollPoints.append(ScrollPoint(start: start, end: end))
            
            
            callback()
            }, failureCallback: { error in
               callback()
        })
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 + oldStories.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return stories.count
        } else {
            return oldStories[section - 1].count
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        return 30.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return UIView()
        }
        
        let view = UIView(frame: CGRectMake(0, 0, screenSize.width, 30))
        view.backgroundColor = navigationColor
        
        let dateLabel = UILabel(frame: view.bounds)
        dateLabel.text = dates[section - 1]
        dateLabel.textColor = whiteColor
        dateLabel.font = Font.font(size: 12)
        dateLabel.textAlignment = .Center
        view.addSubview(dateLabel)
        
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constant.reuseIdentifier, forIndexPath: indexPath) as! StoryCell
        cell.updateStory(self.handleCell(indexPath))
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return tableView.fd_heightForCellWithIdentifier(Constant.reuseIdentifier) { cell in
//            (cell as! StoryCell).updateStory(self.handleCell(indexPath))
//        }
        return 93.0
    }
    
    private func handleCell(indexPath: NSIndexPath)-> Story {
        return indexPath.section == 0 ? stories[indexPath.row] : oldStories[indexPath.section - 1][indexPath.row]
    }
    
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let MAX: CGFloat = 90.0
        let header = self.tableView.tableHeaderView as! ParallaxHeaderView
        header.layoutView(offset: scrollView.contentOffset)
        if offsetY > -navigationBarHeight {
            let alpha = min(1, (navigationBarHeight + offsetY)/(navigationBarHeight + MAX))
            self.navigationController?.navigationBar.dyl_setBackgroundColor(navigationColor.colorWithAlphaComponent(alpha))
            
            for (index, scrollPoint) in scrollPoints.enumerate() {
                if index == 0 {
                    self.title = "今日要闻"
                } else {
                    if offsetY >= CGFloat(scrollPoint.start) &&  offsetY <= CGFloat(scrollPoint.end){
                        self.title = dates[index - 1]
                    }
                }
            }
            
        } else {
            // TODO
            self.navigationController?.navigationBar.dyl_setBackgroundColor(navigationColor.colorWithAlphaComponent(0))
        }
    }
    
}

extension MainViewController: ParallaxHeaderViewDelegate {
    func stopScroll() {
        self.tableView.contentOffset.y = -154
    }
}


