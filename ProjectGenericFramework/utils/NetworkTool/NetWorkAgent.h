//
//  NetWorkAgent.h
//  ProjectGenericFramework
//
//  Created by joe on 2017/8/2.
//  Copyright © 2017年 joe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BaseRequest;

@interface NetWorkAgent : NSObject
// 不可用
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;
// 单例
+ (NetWorkAgent *)sharedInstance;

- (void)addRequest:(BaseRequest *)request;
// 暂未加此功能
- (void)removeRequest:(BaseRequest *)request;
@end

NS_ASSUME_NONNULL_END
