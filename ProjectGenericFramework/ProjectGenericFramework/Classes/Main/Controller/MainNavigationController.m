//
//  MainNavigationController.m
//  ProjectGenericFramework
//
//  Created by joe on 2016/12/14.
//  Copyright © 2016年 joe. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()<UINavigationControllerDelegate>
@end

@implementation MainNavigationController
#pragma mark - life cycle
+ (void)initialize
{
    // 设置项目中item的主题样式
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 设置代理 */
    self.delegate = self;
    
    __weak typeof(self)weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}
#pragma mark - delegate
/** UINavigationControllerDelegate */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { //非根控制器
        /** push时隐藏bar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        /** left bar button item */
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNorImage:@"navigationbar_back" higImage:@"navigationbar_back_highlighted" targe:self action:@selector(leftDown)];
        
        /** right bar button item */
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNorImage:@"navigationbar_more" higImage:@"navigationbar_more_highlighted" targe:self action:@selector(rightDown)];
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    /**  */
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
#pragma mark - event response
#pragma mark - private methods
- (void)leftDown
{
    [self popViewControllerAnimated:YES];
}

- (void)rightDown
{
    [self popToRootViewControllerAnimated:YES];
}
#pragma mark - getters and setters
@end
