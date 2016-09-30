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
    
    var direction: Direction = .Up
    
    // Overlaypresentable
    lazy var overlay: NoMoreDataView = {
        let view = NoMoreDataView(frame: self.view.bounds)
        return view
    }()
    
    // NextPageLoadable
    var data = [[Comment]]()
    var nextPageState = NextPageState<String>()
    
    var newID = ""
    var longComments = [Comment]()
    var shortComments = [Comment]()
    
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
        loadNext()
    }
    
    func directAction(gesture: UITapGestureRecognizer) {
        switch direction {
        case .Down:
            data[1] = [Comment]()
            direction = .Up
        case .Up:
            data[1] = shortComments
            direction = .Down
        }
        tableView.reloadData()
        dispatch_async(dispatch_get_main_queue()) {
            if self.data[1].count > 0 {
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition: .Top, animated: true)
            } else {
                if self.data[0].count > 0 {
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)

                }
            }
        }
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
        
        if section == 0 {
            label.text = "\(self.longComments.count)条长评"
        } else if self.shortComments.count > 0  {
            label.text = "\(self.shortComments.count)条短评"
            
            let arrow = DoubleArrow()
            view.addSubview(arrow)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(directAction(_:)))
            arrow.addGestureRecognizer(gesture)
            view.userInteractionEnabled = true
            
            switch direction {
            case .Up: arrow.transform = CGAffineTransformIdentity
            case .Down: arrow.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            }
            
            let line = UIView()
            line.backgroundColor = lineColor
            view.addSubview(line)
            
            arrow.snp_makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalTo(-leftSpace)
                make.width.equalTo(20)
                make.height.equalTo(15)
            }
            line.snp_makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(0.5)
            }
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
        return data.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.fd_heightForCellWithIdentifier(Constant.reuseIdetifier) { cell in
            (cell as! CommentCell).update(self.data[indexPath.section][indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constant.reuseIdetifier, forIndexPath: indexPath) as! CommentCell
        cell.update(self.data[indexPath.section][indexPath.row])
        return cell
    }
    
}

extension CommentViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

extension CommentViewController: DJOverlayPresentable {
    // TODO
}

extension CommentViewController: NextPageLoadable {
    
    func performLoad(successHandler: (rows: [[Comment]], hasNext: Bool, lastId: String?) -> (), failHandler: () -> ()) {
        let group = dispatch_group_create()
        
        // get long comments
        dispatch_group_enter(group)
        DailyRequest.get(URLString: URLS.news_long_comment(newID), successCallback: { data in
            let comments = data["comments"].arrayValue
            for dic in comments {
                var comment = Comment()
                comment.convert(dic.dictionaryValue)
                self.longComments.append(comment)
            }
            dispatch_group_leave(group)
        })
        
        // get short comments
        dispatch_group_enter(group)
        DailyRequest.get(URLString: URLS.news_short_comment(newID), successCallback: { data in
            let comments = data["comments"].arrayValue
            for dic in comments {
                var comment = Comment()
                comment.convert(dic.dictionaryValue)
                self.shortComments.append(comment)
            }
            dispatch_group_leave(group)
        })
        
        dispatch_group_notify(group, dispatch_get_main_queue(), {
            var comments = [[Comment]]()
            comments.append(self.longComments.count > 0 ? self.longComments : [Comment]())
            comments.append([Comment]())
            self.displayOverlay(self.longComments.count + self.shortComments.count == 0)
            self.title = "\(self.longComments.count + self.shortComments.count)条评论"
            
            successHandler(rows: comments, hasNext: true, lastId: "")
        })
    }
    
}
