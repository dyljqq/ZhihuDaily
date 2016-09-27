//
//  EditorViewController.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/31.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    
    struct Constant {
        static let reuseIdentifier = "cell"
    }
    
    lazy var overlay: NoMoreDataView = {
        let view = NoMoreDataView(frame: self.view.bounds)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
        tableView.backgroundColor = whiteColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerClass(EditorCell.self, forCellReuseIdentifier: Constant.reuseIdentifier)
        return tableView
    }()
    
    var editors = [Editor]() {
        didSet {
            // TODO
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setup() {
        
        self.title = "主编"
        self.view.addSubview(tableView)
        self.setLeftNavigationItemBack()
    }
    
}

extension EditorViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constant.reuseIdentifier, forIndexPath: indexPath) as! EditorCell
        cell.accessoryType = .DisclosureIndicator
        cell.update(editors[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}

extension EditorViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let editor = editors[indexPath.row]
        let webViewController = WebViewController()
        webViewController.name = editor.name
        webViewController.URLString = editor.url
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
}
