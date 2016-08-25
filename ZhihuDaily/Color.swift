//
//  Color.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/23.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit

func RGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat? = 1.0)-> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha ?? 1.0)
}


let textGrayColor = RGB(175, green: 175, blue: 175)
let fontColor = RGB(115, green: 115, blue: 115) // 偏深的字体颜色 通用
let backColor = RGB(241, green: 241, blue: 241)
let navigationColor = RGB(1, green: 131, blue: 209)
let blackColor = UIColor.blackColor()
let whiteColor = UIColor.whiteColor()
let clearColor = UIColor.clearColor()
