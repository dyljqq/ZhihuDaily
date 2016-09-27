//
//  ContentViewController.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/8.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

enum Direction {
    case Down
    case Up
}

class ContentViewController: UIViewController {
    
    struct Constant {
        static let maxOffsetY: CGFloat = 223
    }
    
    lazy var refreshView: RefreshView = {
        let refreshView = RefreshView(frame: CGRectMake(0, -45, screenSize.width, 45))
        return refreshView
    }()
    
    lazy var statusBarView: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, screenSize.width, 0))
        view.backgroundColor = whiteColor
        return view
    }()
    
    lazy var webView: UIWebView = {
        let webView = UIWebView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height - 44))
        webView.backgroundColor = whiteColor
        webView.delegate = self
        webView.scrollView.delegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        return webView
    }()
    
    lazy var bannerView: BannerView = {
        let bannerView = BannerView(frame: CGRectMake(0, 0, screenSize.width, Constant.maxOffsetY))
        return bannerView
    }()
    
    lazy var footerBar: FooterBar = {
        let footerBar = FooterBar(frame: CGRectMake(0, screenSize.height - 44, screenSize.width, 44))
        return footerBar
    }()
    
    var headView: ParallaxHeaderView!
    var URLString: String = ""
    var indexPath = NSIndexPath(forRow: 0, inSection: 0)
    var dragging = true
    
    var transition = RightTransition()
    
    var isStory = true // story or theme
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    private func setup() {
        self.view.backgroundColor = whiteColor
        self.view.addSubview(self.statusBarView)
        self.view.addSubview(self.webView)
        self.view.addSubview(self.footerBar)
        
        if isStory {
            headView = ParallaxHeaderView.parallaxHeader(subview: bannerView, size: bannerView.frame.size, type: .WebView)
            headView.delegate = self
            headView.maxContentOffset = 85
            self.webView.scrollView.addSubview(headView)
        } else {
            refreshView.contentLabel.textColor = textGrayColor
        }
        self.webView.scrollView.addSubview(refreshView)
        
        getData()
        
        self.footerBar.callback = { index in
            switch index {
            case 0: self.back()
            case 1: self.next()
            case 4: self.toComment()
            default: break
            }
        }
        alterRefreshView()
        print("frame: \(self.view.frame), webview frame: \(self.webView.frame)")
    }
    
    private func getData() {
        DailyRequest.get(URLString: URLString, successCallback: { data in
            guard let body = data["body"] as? String else {
                print("body is not exist...")
                return
            }
            guard let array = data["css"] as? [String] else {
                return
            }
            let css = array[0]
            var html = "<html>"
            html += "<head>"
            html += "<link rel=\"stylesheet\" href="
            html += css
            html += "</head>"
            html += "<body>"
            html += body
            html += "</body>"
            html += "</html>"
            self.webView.loadHTMLString(html, baseURL: nil)
            
            guard let images = data["images"] as? [String] else {
                print("no images...")
                return
            }
            self.bannerView.update(images[0] as String, content: data["title"] as? String ?? "")
        })
    }
    
    private func alterRefreshView() {
        if indexPath.section == 0 && indexPath.row == 0 {
            refreshView.contentLabel.text = "已经是第一篇了"
            refreshView.arrowImageView.hidden = true
        } else {
            refreshView.contentLabel.text = "载入上一篇"
            refreshView.arrowImageView.hidden = false
        }
    }
    
    func loadNewStory(type: Direction) {
        
        alterRefreshView()
        var page = 1
        var distance: CGFloat = 0
        switch type {
        case .Up:
            distance = -screenSize.height
            page = -1
        default: distance = screenSize.height
        }
        
        let upTransform = CGAffineTransformMakeTranslation(0, distance)
        let downTransform = CGAffineTransformMakeTranslation(0, -distance)
        
        guard let (ip, newID) = nextValue(page) else {
            return
        }
        
        let toWebViewController = ContentViewController()
        toWebViewController.indexPath = ip
        toWebViewController.URLString = URLS.news_content_url(newID)
        toWebViewController.isStory = isStory
        let toView = toWebViewController.view
        toView.frame = self.view.frame
        toView.transform = upTransform
        self.view.addSubview(toView)
        self.addChildViewController(toWebViewController)
        
        let fromView = self.view.snapshotViewAfterScreenUpdates(true)
        self.view.addSubview(fromView)
        
        UIView.animateWithDuration(0.5, animations: {
            fromView.transform = downTransform
            toView.transform = CGAffineTransformIdentity
            }, completion: { finished in
                self.webView.removeFromSuperview()
                fromView.removeFromSuperview()
        })
        
    }
    
    private func nextValue(page: Int)-> (indexPath: NSIndexPath, newID: String)? {
        let ip = NSIndexPath(forRow: indexPath.row + page, inSection: indexPath.section)
        if isStory {
            if (ip.section == 0 && ip.row == -1) || (ip.section == appDelegate.oldStories.count && ip.row == appDelegate.oldStories[ip.section].count) {
                return nil
            } else if ip.row == appDelegate.stories.count || ip.row == appDelegate.oldStories[ip.section].count {
                let indexP = NSIndexPath(forRow: 0, inSection: ip.section + 1)
                return (indexP, indexP.section == 0 ? appDelegate.stories[indexP.row].id : appDelegate.oldStories[indexP.section][0].id)
            } else {
                return (ip, ip.section == 0 ? appDelegate.stories[ip.row].id : appDelegate.oldStories[ip.section][0].id)
            }
        } else {
            if ip.row == -1 || ip.row == appDelegate.themeContents.stories.count {
                return nil
            } else {
                return (ip, appDelegate.themeContents.stories[ip.row].id)
            }
        }
    }
    
}

extension ContentViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}

extension ContentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if isStory {
            headView.layoutView(offset: scrollView.contentOffset)
        }
        if offsetY >= -55 && offsetY <= 0 {
            refreshView.direction = .Down
            dragging = true
        } else if offsetY  < -55 {
            refreshView.direction = .Up
            if !dragging {
                dragging = false
                loadNewStory(.Up)
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

extension ContentViewController: ParallaxHeaderViewDelegate {
    func stopScroll() {
        webView.scrollView.contentOffset.y = -85
    }
}

// footer bar callback
extension ContentViewController {
    
    private func back() {
//        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func next() {
        loadNewStory(.Down)
    }
    
    private func toComment() {
        let commentViewController = CommentViewController()
        commentViewController.newID = indexPath.section == 0 ? appDelegate.stories[indexPath.row].id : appDelegate.oldStories[indexPath.section - 1][indexPath.row].id
        commentViewController.transitioningDelegate = self
//        presentViewController(commentViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(commentViewController, animated: true)
    }
    
}

extension ContentViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
