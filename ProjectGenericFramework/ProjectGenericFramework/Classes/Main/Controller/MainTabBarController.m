//
//  MainTabBarController.m
//  ProjectGenericFramework
//
//  Created by joe on 2016/12/14.
//  Copyright © 2016年 joe. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "PublishViewController.h"
#import "MainNavigationController.h"
#import "MainTabBarControllerTabBar.h"

@interface MainTabBarController () <MainTabBarControllerTabBarDelegate>
@property (nonatomic, strong) HomeViewController *homeVc;
@property (nonatomic, strong) ProfileViewController *profileVc;
@end

@implementation MainTabBarController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加子控制器
    [self addChildVc:self.homeVc title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    [self addChildVc:self.profileVc title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    MainTabBarControllerTabBar *tabBar = [[MainTabBarControllerTabBar alloc] init];
    tabBar.customDelegate = self;
    /** KVC */
    [self setValue:tabBar forKey:@"tabBar"];
}

#pragma mark - delegate
// MainTabBarControllerTabBarDelegate 加号按钮代理
- (void)tabBarDidClickPlusButton:(MainTabBarControllerTabBar *)tabBar
{
    PublishViewController *vc = [[PublishViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - event response
#pragma mark - private methods
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    
    /** 设置tabbar title  和 navigationbar title */
    childVc.title = title;
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} forState:UIControlStateSelected];
    /** 设置图片 */
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    /** 添加子控制器 */
    MainNavigationController *navigationVc = [[MainNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:navigationVc];
}
#pragma mark - getters and setters
- (HomeViewController *)homeVc
{
    if (_homeVc == nil) {
        _homeVc = [[HomeViewController alloc] init];
    }
    return _homeVc;
}
- (ProfileViewController *)profileVc
{
    if (_profileVc == nil) {
        _profileVc = [[ProfileViewController alloc] init];
    }
    return _profileVc;
}
@end
