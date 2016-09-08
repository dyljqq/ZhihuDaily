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
        static let editorIdentifier = "editorCell"
        static let maxOffsetY: CGFloat = navigationBarHeight
    }
    
    var themeId = 0 {
        didSet {
            getData()
        }
    }
    var themeName = ""
    
    private lazy var titleView: TitleView = {
        let view = TitleView(frame: CGRectMake(0, 0, 150, 25))
        view.backgroundColor = clearColor
        view.showCircleView = false
        view.titleLabel.text = self.themeName
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
        tableView.backgroundColor = whiteColor
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(StoryCell.self, forCellReuseIdentifier: Constant.reuseIdentifier)
        tableView.registerClass(ThemeEditorCell.self, forCellReuseIdentifier: Constant.editorIdentifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    var navImageView = UIImageView(frame: CGRectMake(0, 0, screenSize.width, navigationBarHeight))
    
    var headerView: ParallaxHeaderView?
    
    var themeContents: ThemeContent = ThemeContent()
    var stories = [Story]()
    var dragging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.dyl_setBackgroundColor(clearColor)
    }
    
    private func setup() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        setNavigation()
        
        self.headerView = ParallaxHeaderView.parallaxHeader(subview: self.navImageView, size: CGSizeMake(screenSize.width, Constant.maxOffsetY), type: HeaderType.Blur)
        self.headerView!.delegate = self
        self.tableView.tableHeaderView = headerView
        
        self.view.addSubview(self.tableView)
    }
    
    private func setNavigation() {
        self.navigationItem.titleView = self.titleView
        
        let left = UIBarButtonItem(image: UIImage(named: "left_back"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        left.tintColor = whiteColor
        navigationItem.setLeftBarButtonItem(left, animated: true)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    func getData(callback: (()-> ())? = nil) {
        self.titleView.titleLabel.text = themeName
        ThemeRequest.getThemeContent(themeId) { themeContent in
            self.themeContents = themeContent
            self.stories = themeContent.stories
            self.navImageView.kf_setImageWithURL(NSURL(string: themeContent.background), placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: { image, _, _, _ in
                if let image = image {
                    if let headerView = self.headerView {
                        headerView.blurImage = image
                    }
                }
            })
            self.tableView.reloadData()
            
            if let callback = callback {
                callback()
            }
        }
    }
    
}

extension ThemeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constant.editorIdentifier, forIndexPath: indexPath) as! ThemeEditorCell
            cell.editors = themeContents.editors
            cell.accessoryType = .DisclosureIndicator
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constant.reuseIdentifier, forIndexPath: indexPath) as! StoryCell
        cell.updateStory(stories[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 30
        }
        return 93
    }
    
}

extension ThemeViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0 {
            // TODO
            let editorVC = EditorViewController()
            editorVC.editors = themeContents.editors
            self.navigationController?.pushViewController(editorVC, animated: true)
        }
    }
    
}

extension ThemeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let header = tableView.tableHeaderView as! ParallaxHeaderView
        header.layoutWithThemeView(offset: offset)
        
        let offsetY = offset.y
        if offsetY < 0 {
            let rate = abs(offsetY) * 2
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
                    getData {
                        self.titleView.activityView.stopAnimating()
                        self.titleView.showActivityIndicatorView = false
                    }
                }
            }
        } else {
            self.titleView.progress = 0
            self.titleView.showCircleView = false
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dragging = false
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dragging = true
    }
    
}

extension ThemeViewController: ParallaxHeaderViewDelegate {
    func stopScroll() {
        self.tableView.contentOffset.y = -95
    }
}

// helper
extension ThemeViewController {
    
}


