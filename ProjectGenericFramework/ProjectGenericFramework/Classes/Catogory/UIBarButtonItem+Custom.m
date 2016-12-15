//
//  UIBarButtonItem+Custom.m
//  SimpleCostWithOC
//
//  Created by joe on 2016/12/12.
//  Copyright © 2016年 joe. All rights reserved.
//

#import "UIBarButtonItem+Custom.h"

@implementation UIBarButtonItem (Custom)

+ (instancetype)itemWithNorImage:(NSString *)norImageName higImage:(NSString *)higImageName targe:(id)targe action:(SEL)action
{
    // 1.创建按钮
    UIButton *btn = [[UIButton alloc] init];
    // 设置默认状态图片
    [btn setBackgroundImage:[UIImage imageNamed:norImageName] forState:UIControlStateNormal];
    // 设置高亮状态图片
    [btn setBackgroundImage:[UIImage imageNamed:higImageName] forState:UIControlStateHighlighted];
    // 设置frame
    btn.size = btn.currentBackgroundImage.size;
    [btn sizeToFit];
    // 添加监听事件
    [btn addTarget:targe action:action forControlEvents:UIControlEventTouchUpInside];
    // 返回item
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
