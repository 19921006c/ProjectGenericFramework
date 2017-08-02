//
//  BaseRequest.m
//  ProjectGenericFramework
//
//  Created by joe on 2017/8/2.
//  Copyright © 2017年 joe. All rights reserved.
//

#import "BaseRequest.h"
#import "NetWorkAgent.h"

@implementation BaseRequest
#pragma mark - Request and Response Information

- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
    return self.response.statusCode;
}

- (NSDictionary *)responseHeaders {
    return self.response.allHeaderFields;
}

- (NSURLRequest *)currentRequest {
    return self.requestTask.currentRequest;
}

- (NSURLRequest *)originalRequest {
    return self.requestTask.originalRequest;
}



#pragma mark -
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.baseUrl = @"";
        self.requestUrl = @"";
        self.requestTimeoutInterval = 20;
        self.requestArgument = nil;
        self.requestHeaderField = nil;
    }
    return self;
}
- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.uploadProgressBlock = nil;
    self.downloadProgressBlock = nil;
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (void)startWithCompletionBlockWithSuccess:(nullable YMRequestCompletionBlock)success
                                    failure:(nullable YMRequestCompletionBlock)failure
{
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    [[NetWorkAgent sharedInstance]addRequest:self];
}
- (void)uploadFileWithprogressBlock:(nullable AFURLSessionTaskProgressBlock)progress
                            success:(nullable YMRequestCompletionBlock)success
                            failure:(nullable YMRequestCompletionBlock)failure;
{
    self.uploadProgressBlock = progress;
    [self startWithCompletionBlockWithSuccess:success failure:failure];
}
- (void)downloadWithBlock:(AFURLSessionTaskProgressBlock)progress
                  success:(YMRequestCompletionBlock)success
                  failure:(YMRequestCompletionBlock)failure
{
    self.downloadProgressBlock = progress;
    [self startWithCompletionBlockWithSuccess:success failure:failure];
}

// 取消
- (void)cancel
{
    [[NetWorkAgent sharedInstance] removeRequest:self];
}
#pragma mark - description
//- (NSString *)description{
//    return @"YMBaseRequest";
//}

@end
