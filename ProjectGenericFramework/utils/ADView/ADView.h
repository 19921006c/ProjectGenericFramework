//
//  ADView.h
//  ProjectGenericFramework
//
//  Created by joe on 2017/7/26.
//  Copyright © 2017年 joe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapBlock)();

@interface ADView : UIView


- (instancetype)initWithFrame:(CGRect)frame tapBlock:(TapBlock)tapBlock;


/**
 现实广告
 */
- (void)show;

@property (nonatomic, copy) NSString *filePath;

@end
