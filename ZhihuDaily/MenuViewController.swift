//
//  MenuViewController.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/30.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    struct Constant {
        static let cellReuseIndentifier = "cell"
        static let homeCellReuseIndentifier = "homeCell"
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 0, screenSize.width / 2, screenSize.height - 40))
        tableView.backgroundColor = menuBackgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.tableHeaderView = self.tableHeaderView()
        tableView.registerClass(ThemeCell.self, forCellReuseIdentifier: Constant.cellReuseIndentifier)
        tableView.registerClass(HomeThemeCell.self, forCellReuseIdentifier: Constant.homeCellReuseIndentifier)
        return tableView
    }()
    
    lazy var footerView: UIImageView = {
        let imageView = UIImageView(frame: CGRectMake(0, screenSize.height - 40, screenSize.width / 2, 40))
        imageView.image = UIImage(named: "placeHolder")
        return imageView
    }()
    
    lazy var gradientView: UIView = {
        let view = UIView(frame: CGRectMake(0, screenSize.height - 40 - 50, screenSize.width / 2, 50))
        return view
    }()
    
    var themes = [Theme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        self.themes = appDelegate.themes
        
        self.view.backgroundColor = menuBackgroundColor
        self.addGradientLayer()
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.footerView)
        self.view.addSubview(self.gradientView)
        
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: .Top)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constant.homeCellReuseIndentifier, forIndexPath: indexPath) as! HomeThemeCell
            cell.update(themes[0])
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(Constant.cellReuseIndentifier, forIndexPath: indexPath) as! ThemeCell
        cell.update(themes[indexPath.row])
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            self.revealViewController().pushFrontViewController(appDelegate.navigationController, animated: true)
        } else {
            if let topVC = appDelegate.themeNavigationVC.topViewController as? ThemeViewController {
                topVC.themeName = themes[indexPath.row].name
                topVC.themeId = themes[indexPath.row].id
                self.revealViewController().pushFrontViewController(appDelegate.themeNavigationVC, animated: true)
            }
        }
    }
    
}

// helper
extension MenuViewController {
    
    private func tableHeaderView()-> UIView {
        let view = UIView(frame: CGRectMake(0, 0, screenSize.width / 2, 100))
        view.backgroundColor = clearColor
        
        let avatar = UIImageView()
        avatar.image = UIImage(named: "ContentImage2")
        avatar.layer.cornerRadius = 20
        avatar.layer.masksToBounds = true
        view.addSubview(avatar)
        
        let contentLabel = UILabel()
        contentLabel.text = "请登录"
        contentLabel.textColor = whiteColor
        contentLabel.font = Font.font(size: 15)
        view.addSubview(contentLabel)
        
        avatar.snp_makeConstraints { make in
            make.top.equalTo(40)
            make.width.height.equalTo(40)
            make.left.equalTo(leftSpace)
        }
        contentLabel.snp_makeConstraints { make in
            make.left.equalTo(avatar.snp_right).offset(10)
            make.centerY.equalTo(avatar)
        }
        
        return view
    }
    
    private func addGradientLayer() {
        let color1 = menuBackgroundColor.CGColor
        let color2 = RGB(19, green: 26, blue: 32, alpha: 0.0).CGColor
        let colors = [color1, color2]
        let locations = [0.0, 1.0]
        
        let footerLayer = CAGradientLayer()
        footerLayer.colors = colors
        footerLayer.locations = locations
        footerLayer.frame = self.gradientView.bounds
        
        self.gradientView.layer.insertSublayer(footerLayer, atIndex: 0)
    }
    
}

