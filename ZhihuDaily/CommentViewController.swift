//
//  CommentViewController.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/9.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    struct Constant {
        static let reuseIdetifier = "cell"
    }
    
    var newID = ""
    var longComments = [Comment]()
    var shortComments = [Comment]()
    var comments = [[Comment]]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
        tableView.backgroundColor = whiteColor
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(CommentCell.self, forCellReuseIdentifier: Constant.reuseIdetifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
    }

    private func setup() {
        self.view.backgroundColor = whiteColor
        self.view.addSubview(self.tableView)
        
        self.setLeftNavigationItemBack()
        getData()
    }
    
    private func getData() {
        
        let group = dispatch_group_create()
        
        // get long comments
        dispatch_group_enter(group)
        DailyRequest.get(URLString: URLS.news_long_comment(newID), successCallback: { data in
            guard let comments = data["comments"] as? [[String: AnyObject]] else {
                return
            }
            for dic in comments {
                var comment = Comment()
                comment.convert(dic)
                self.longComments.append(comment)
            }
            dispatch_group_leave(group)
        })
        
        // get short comments
        dispatch_group_enter(group)
        DailyRequest.get(URLString: URLS.news_short_comment(newID), successCallback: { data in
            guard let comments = data["comments"] as? [[String: AnyObject]] else {
                return
            }
            for dic in comments {
                var comment = Comment()
                comment.convert(dic)
                self.shortComments.append(comment)
            }
            dispatch_group_leave(group)
        })
        
        dispatch_group_notify(group, dispatch_get_main_queue(), {
            // TODO
            
            if self.longComments.count > 0 {
                self.comments.append(self.longComments)
            }
            if self.shortComments.count > 0 {
                self.comments.append(self.shortComments)
            }
            self.title = "\(self.comments.count)条评论"
            self.tableView.reloadData()
        })
        
    }
    
}

extension CommentViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, screenSize.width, 30))
        view.backgroundColor = whiteColor
        
        let label = UILabel()
        label.textColor = fontColor
        label.font = Font.font(size: 15)
        view.addSubview(label)
        
        if section == 0 && self.longComments.count > 0 {
            label.text = "\(self.longComments.count)条长评"
        } else if self.shortComments.count > 0  {
            label.text = "\(self.shortComments.count)条短评"
        }
        
        let line = UIView()
        line.backgroundColor = lineColor
        view.addSubview(line)
        
        label.snp_makeConstraints { make in
            make.centerY.equalTo(view)
            make.left.equalTo(leftSpace)
        }
        line.snp_makeConstraints { make in
            make.bottom.equalTo(view).offset(0.5)
            make.height.equalTo(0.5)
            make.left.right.equalTo(view)
        }
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments[section].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.fd_heightForCellWithIdentifier(Constant.reuseIdetifier) { cell in
            (cell as! CommentCell).update(self.comments[indexPath.section][indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constant.reuseIdetifier, forIndexPath: indexPath) as! CommentCell
        cell.update(self.comments[indexPath.section][indexPath.row])
        return cell
    }
    
}

extension CommentViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
