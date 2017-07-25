//
//  MainTabBarControllerTabBar.h
//  ProjectGenericFramework
//
//  Created by joe on 2016/12/14.
//  Copyright © 2016年 joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTabBarControllerTabBar;

@protocol MainTabBarControllerTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton:(MainTabBarControllerTabBar *)tabBar;

@end

@interface MainTabBarControllerTabBar : UITabBar

@property (nonatomic, weak) id<MainTabBarControllerTabBarDelegate> customDelegate;

@end
