//
//  ThemeViewController.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/30.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController {

    struct Constant {
        static let reuseIdentifier = "StoryCell"
        static let maxOffsetY: CGFloat = navigationBarHeight
    }
    
    var themeId = 5
    
    private lazy var titleView: TitleView = {
        let view = TitleView(frame: CGRectMake(0, 0, 150, 25))
        view.backgroundColor = clearColor
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
        tableView.backgroundColor = whiteColor
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(StoryCell.self, forCellReuseIdentifier: Constant.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.hidden = true
        return tableView
    }()
    
    private lazy var navImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRectMake(0, 0, screenSize.width, navigationBarHeight))
        return imageView
    }()
    
    var themeContents: ThemeContent?
    var stories = [Story]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
    }
    
    private func setup() {
        self.titleView.titleLabel.text = "不许无聊"
        self.navigationItem.titleView = self.titleView
        self.navigationController?.navigationBar.dyl_setBackgroundColor(clearColor)
        
        let headerView = ParallaxHeaderView.parallaxHeader(subview: self.navImageView, size: CGSizeMake(screenSize.width, Constant.maxOffsetY))
        headerView.delegate = self
        self.tableView.tableHeaderView = headerView
        
        self.view.addSubview(self.tableView)
    }
    
    func getData() {
        ThemeRequest.getThemeContent(themeId) { themeContent in
            self.themeContents = themeContent
            self.stories = themeContent.stories
            self.tableView.reloadData()
        }
    }
    
}

extension ThemeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constant.reuseIdentifier, forIndexPath: indexPath) as! StoryCell
        cell.updateStory(stories[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 93
    }
    
}

extension ThemeViewController: UITableViewDelegate {
    
}

extension ThemeViewController: UIScrollViewDelegate {
    
}

extension ThemeViewController: ParallaxHeaderViewDelegate {
    func stopScroll() {
        self.tableView.contentOffset.y = -navigationBarHeight
    }
}

// helper
extension ThemeViewController {
    
    
    
}


