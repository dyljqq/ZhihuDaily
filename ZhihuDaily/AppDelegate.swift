//
//  AppDelegate.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/22.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftDate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var slideVC: DYLSlideViewController!
    var navigationController: UINavigationController?
    var themeNavigationVC: UINavigationController!
    var revealViewController: SWRevealViewController?
    var themes = [Theme]()
    
    var storyRequest = StoryRequest()
    var banners = [Story]()
    var stories = [Story]()
    var oldStories = [[Story]]()
    var dates = [String]()
    var scrollPoints = [ScrollPoint]()
    
    var startImageURL: String = ""

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = clearColor
        
        themeNavigationVC = UINavigationController(rootViewController: ThemeViewController())
        
        self.navigationController = UINavigationController(rootViewController: MainViewController())
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: whiteColor]
        self.themeNavigationVC?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: whiteColor]
        
        revealViewController = SWRevealViewController.init(rearViewController: MenuViewController(), frontViewController: navigationController)
        
        self.window?.rootViewController = revealViewController
        self.window?.makeKeyAndVisible()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // delete the black line
        for subview in (self.themeNavigationVC?.navigationBar.subviews)! {
            if subview.isKindOfClass(UIImageView.self) {
                subview.hidden = true
            }
        }
        getData(nil)
        getMenu()
        getStartImageURL()
        
        return true
    }
    
    func getData(callback: (()-> ())?) {
        storyRequest.getData { banners, stories, oldStories, dates, scrollPoints in
            self.banners = banners
            self.stories = stories
            self.oldStories = oldStories
            self.dates = dates
            self.scrollPoints = scrollPoints
            NSNotificationCenter.defaultCenter().postNotificationName(story_notification, object: nil)
            if let callback = callback {
                callback()
            }
        }
        
    }
    
    func getMenu() {
        ThemeRequest.getThemes { themes in
            self.themes = themes
        }
    }
    
    func getStartImageURL() {
        DailyRequest.get(URLString: URLS.start_image_url, successCallback: { value in
            if let urlString = value["img"] as? String {
                NSNotificationCenter.defaultCenter().postNotificationName(start_image_notification, object: nil, userInfo: ["startImageURL": urlString])
            }
        })
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

