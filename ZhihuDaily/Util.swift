//
//  Util.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/23.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

let screenBounds = UIScreen.mainScreen().bounds
let screenSize = screenBounds.size
let screenScale = UIScreen.mainScreen().scale
let resolutionRate = CGSize(width: screenSize.width * screenScale, height: screenSize.height * screenScale)
let navigationBarHeight: CGFloat = 64.0

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

let leftSpace = 15.0
let cornerRadius: CGFloat = 5.0