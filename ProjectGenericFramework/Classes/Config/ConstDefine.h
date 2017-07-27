//
//  ConstDefine.h
//  SimpleCostWithOC
//
//  Created by joe on 2016/12/8.
//  Copyright © 2016年 joe. All rights reserved.
//
//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

/** 定义常量 */
#ifndef ConstDefine_h
#define ConstDefine_h

#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenWidth kMainScreenBounds.size.width
#define kScreenHeight kMainScreenBounds.size.height
#define kNavigationBarHeight 64
#define kTabBarHeight 49
#define kTabBarBackgroundColor [UIColor colorWithHexString:@"#60C2EB"]
#define kTabBarTitleColor [UIColor colorWithHexString:@"#808284"]
#endif /* ConstDefine_h */
