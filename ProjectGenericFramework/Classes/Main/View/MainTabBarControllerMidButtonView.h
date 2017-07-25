//
//  MainTabBarControllerMidButtonView.h
//  ProjectGenericFramework
//
//  Created by joe on 2016/12/15.
//  Copyright © 2016年 joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainTabBarControllerMidButtonViewDelegate <NSObject>

@optional
- (void)didSelectedMidBtn;

@end
@interface MainTabBarControllerMidButtonView : UIView
@property (nonatomic, weak) id<MainTabBarControllerMidButtonViewDelegate> delegate;

@end
