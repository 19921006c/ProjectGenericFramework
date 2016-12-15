//
//  MainTabBarControllerTabBar.m
//  ProjectGenericFramework
//
//  Created by joe on 2016/12/14.
//  Copyright © 2016年 joe. All rights reserved.
//
#define kTabBarItemCount 3

#import "MainTabBarControllerTabBar.h"
#import "MainTabBarControllerMidButtonView.h"
@interface MainTabBarControllerTabBar ()
//@property (nonatomic, strong) UIButton *plusBtn;
@property (nonatomic, strong) MainTabBarControllerMidButtonView *midBtnView;
@end

@implementation MainTabBarControllerTabBar

#pragma mark - life cycle
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = kTabBarItemCount;
    [self addSubview:self.midBtnView];
    // 1.设置加号按钮的位置
    CGFloat midBtnViewWidth = self.width / count;
    CGFloat midBtnViewHeight = self.height;
    CGFloat midBtnViewX = (self.width - midBtnViewWidth) * 0.5;
    CGFloat midBtnViewY = 0;
    self.midBtnView.frame = CGRectMake(midBtnViewX, midBtnViewY, midBtnViewWidth, midBtnViewHeight);

    // 2.设置其他tabbarButton的frame
    CGFloat tabBarButtonW = self.width / count;
    CGFloat tabBarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置x
            child.x = tabBarButtonIndex * tabBarButtonW;
            // 设置宽度
            child.width = tabBarButtonW;
            // 增加索引
            tabBarButtonIndex++;
            if (tabBarButtonIndex == count - 2) {
                tabBarButtonIndex++;
            }
        }
    }
}
#pragma mark - delegate
#pragma mark - event response
/**
 *  加号按钮点击
 */
- (void)plusBtnAction
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.customDelegate tabBarDidClickPlusButton:self];
    }
}
#pragma mark - private methods
#pragma mark - getters and setters
- (MainTabBarControllerMidButtonView *)midBtnView
{
    if (_midBtnView == nil) {
        _midBtnView = [[MainTabBarControllerMidButtonView alloc] init];
    }
    return _midBtnView;
}
@end
