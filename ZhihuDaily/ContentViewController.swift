//
//  ContentViewController.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/9/8.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    struct Constant {
        static let maxOffsetY: CGFloat = 223
    }
    
    lazy var webView: UIWebView = {
        let webView = UIWebView(frame: CGRectMake(0, -20, screenSize.width, screenSize.height + 20))
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.view.backgroundColor = whiteColor
        self.view.addSubview(self.webView)
        self.view.addSubview(self.footerBar)
        
        headView = ParallaxHeaderView.parallaxHeader(subview: bannerView, size: bannerView.frame.size, type: .WebView)
        headView.delegate = self
        headView.maxContentOffset = 85
        self.webView.scrollView.addSubview(headView)
        
        getData()
        
        self.footerBar.callback = { index in
            switch index {
            case 0: self.back()
            default: break
            }
        }
    }
    
    private func getData() {
        DailyRequest.get(URLString: URLString, successCallback: { data in
            guard let body = data["body"] as? String else {
                print("body is not exist...")
                return
            }
            let css = data["css"]![0] as? String ?? ""
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
    
}

extension ContentViewController: UIWebViewDelegate {
    
}

extension ContentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        headView.layoutView(offset: scrollView.contentOffset)
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func next() {
        // TODO
    }
    
}
