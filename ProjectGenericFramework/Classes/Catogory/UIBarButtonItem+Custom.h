//
//  UIBarButtonItem+Custom.h
//  SimpleCostWithOC
//
//  Created by joe on 2016/12/12.
//  Copyright © 2016年 joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Custom)

+ (instancetype)itemWithNorImage:(NSString *)norImageName higImage:(NSString *)higImageName targe:(id)targe action:(SEL)action;

@end
