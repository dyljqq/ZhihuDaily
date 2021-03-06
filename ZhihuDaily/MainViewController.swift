//
//  ViewController.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/22.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, Navigationable {
    
    struct Constant {
        static let reuseIdentifier = "StoryCell"
        static let maxOffsetY: CGFloat = 154
    }
    
    private var transition = RightTransition()
    @objc 
    private var lauchViewController: LauchViewController = LauchViewController()
    private lazy var topBanner: DYLParallelView = {
        let topBanner = DYLParallelView(frame: CGRectMake(0, 0, 375, Constant.maxOffsetY))
        topBanner.delegate = self
        topBanner.datasource = self
        topBanner.selectedIndex = 0
        topBanner.clipsToBounds = false
        topBanner.backgroundColor = whiteColor
        topBanner.autoresizesSubviews = true
        return topBanner
    }()
    private lazy var titleView: TitleView = {
        let view = TitleView(frame: CGRectMake(0, 0, 150, 25))
        view.backgroundColor = clearColor
        return view
    }()
    private lazy var slideMenu: DYLSlideMenu = {
        let slideMenu = DYLSlideMenu()
        return slideMenu
    }()
    
    private var storyRequest = StoryRequest()
    private var banners = [Story]()
    private var stories = [Story]()
    private var oldStories = [[Story]]()
    private var dates = [String]()
    private var scrollPoints = [ScrollPoint]()
    private var dragging = true
    private var trigger = false
    
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
        self.navigationController?.navigationBar.translucent = true
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        topBanner.showTimer = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        topBanner.showTimer = false
    }
    
    func setup() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(getStory), name: story_notification, object: nil)
        
        self.navigationItem.titleView?.hidden = true
        
        // delete the bottom line
        for subview in (self.navigationController?.navigationBar.subviews)! {
            if subview.isKindOfClass(UIImageView.self) {
                subview.hidden = true
            }
        }
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.slideMenu)
        
        let headerView = ParallaxHeaderView.parallaxHeader(subview: self.topBanner, size: CGSizeMake(375, Constant.maxOffsetY))
        headerView.delegate = self
        self.tableView.tableHeaderView = headerView
        
        lauchViewController.view.alpha = 0.99
        self.addChildViewController(lauchViewController)
        self.view.addSubview(lauchViewController.view)
        
    }
    
    func getStory() {
        self.banners = appDelegate.banners
        self.topBanner.reload()
        
        self.stories = appDelegate.stories
        self.oldStories = appDelegate.oldStories
        self.dates = appDelegate.dates
        self.scrollPoints = appDelegate.scrollPoints
        self.tableView.reloadData()
        
        // reload complete
        dispatch_async(dispatch_get_main_queue()) {
            let lauchImageView = self.lauchViewController.view
            UIView.animateWithDuration(2.5, animations: {
                lauchImageView.alpha = 1.0
                }, completion: { stop in
                    UIView.animateWithDuration(0.2, animations: {
                        self.setNavigation()
                        lauchImageView.alpha = 0.0
                    }) { finished in
                        lauchImageView.removeFromSuperview()
                        self.tableView.hidden = false
                    }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}

extension MainViewController {
    
    func setNavigation() {
        self.navigationItem.titleView?.hidden = false
        self.navigationController?.navigationBar.dyl_setBackgroundColor(clearColor)
        
        // left
        setLeftNavigationItem("menu")
        
        // right
        let right = UIBarButtonItem(image: UIImage(named: "article"), style: .Plain, target: self, action: #selector(articleAction))
        right.tintColor = whiteColor;
        navigationItem.setRightBarButtonItem(right, animated: true)
        
        self.titleView.titleLabel.text = "今日热闻"
        self.navigationItem.titleView = self.titleView
        self.titleView.showCircleView = false
        
    }
    
    func articleAction() {
        // TODO
        navigationController?.pushViewController(ColumnViewController(), animated: true)
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
        let bannerView = BannerView(frame: CGRectMake(0, 0, screenSize.width, Constant.maxOffsetY))
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
        var data = Story()
        if indexPath.section == 0 {
            data = stories[indexPath.row]
        } else {
            data = oldStories[indexPath.section - 1][indexPath.row]
        }
        let contentViewController = ContentViewController()
        contentViewController.URLString = URLS.news_content_url(data.id)
        contentViewController.indexPath = indexPath
        self.navigationController?.pushViewController(contentViewController, animated: true)
    }
    
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (stories.count > 0 ? 1 : 0) + oldStories.count
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
        if offsetY >= -navigationBarHeight {
            dragging = true
            self.titleView.showCircleView = false
            let alpha = min(1, (navigationBarHeight + offsetY)/(navigationBarHeight + MAX))
            self.navigationController?.navigationBar.dyl_setBackgroundColor(navigationColor.colorWithAlphaComponent(alpha))
            
            for (index, scrollPoint) in scrollPoints.enumerate() {
                if index == 0 {
                    self.title = "今日要闻"
                } else {
                    if offsetY >= CGFloat(scrollPoint.start) &&  offsetY <= CGFloat(scrollPoint.end){
                        self.titleView.titleLabel.text = dates[index - 1]
                    }
                }
            }
            
        } else {
            
            self.navigationController?.navigationBar.dyl_setBackgroundColor(navigationColor.colorWithAlphaComponent(0))
            
            let rate = (abs(offsetY) - navigationBarHeight) * 2
            if rate <= 100 {
                if !self.titleView.showCircleView {
                    self.titleView.showCircleView = true
                }
                self.titleView.progress = Int(rate)
            } else {
                self.titleView.progress = 100
                if !dragging {
                    self.titleView.circleView.hidden = true
                    self.titleView.showActivityIndicatorView = true
                    self.titleView.activityView.startAnimating()
                    dragging = true
                    
                    appDelegate.getData {
                        self.titleView.activityView.stopAnimating()
                        self.titleView.showActivityIndicatorView = false
                        self.titleView.showCircleView = false
                        self.trigger = false
                    }
                }
            }
            
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dragging = false
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dragging = true
    }
    
}

extension MainViewController: ParallaxHeaderViewDelegate {
    func stopScroll() {
        self.tableView.contentOffset.y = -Constant.maxOffsetY
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}


