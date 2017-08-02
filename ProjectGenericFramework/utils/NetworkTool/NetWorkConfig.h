//
//  NetWorkConfig.h
//  ProjectGenericFramework
//
//  Created by joe on 2017/8/2.
//  Copyright © 2017年 joe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFSecurityPolicy;

NS_ASSUME_NONNULL_BEGIN
@interface NetWorkConfig : NSObject
// 不可用
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;
// 单例
+ (NetWorkConfig *)sharedInstance;
// baseURL  like "http://www.apple.com/ss/sss/sss". Default is empty string.
@property (nonatomic, strong) NSString *baseUrl;
// 域名      like "http://www.apple.com/". Default is empty string.  独立出来的域名，baseDomain独立的。可以不用~
@property (nonatomic, strong) NSString *baseDomain;
// 安全协议   Default is  [AFSecurityPolicy defaultPolicy]
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;
// 附加的参数 默认是 nil
@property (nonatomic, strong) NSDictionary *additionalArguments;
@end
NS_ASSUME_NONNULL_END
