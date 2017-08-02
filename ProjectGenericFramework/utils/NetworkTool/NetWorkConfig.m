//
//  NetWorkConfig.m
//  ProjectGenericFramework
//
//  Created by joe on 2017/8/2.
//  Copyright © 2017年 joe. All rights reserved.
//

#import "NetWorkConfig.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@implementation NetWorkConfig
+ (NetWorkConfig *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance =  [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _baseUrl = @"";
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
        _additionalArguments = nil;
    }
    return self;
}


#pragma mark - description
//- (NSString *)description{
//    return [NSString stringWithFormat:@"<%@: %p>{ baseURL: %@ } ", NSStringFromClass([self class]), self, self.baseUrl];
//}

@end
