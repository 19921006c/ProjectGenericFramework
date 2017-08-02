//
//  BaseRequest.h
//  ProjectGenericFramework
//
//  Created by joe on 2017/8/2.
//  Copyright © 2017年 joe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// http request method
typedef NS_ENUM(NSInteger, YMRequestMethod) {
    YMRequestMethodGET = 0,
    YMRequestMethodPOST,
    YMRequestMethodHEAD,
    YMRequestMethodPUT,
    YMRequestMethodDELETE,
    YMRequestMethodUpload,
    YMRequestMethodDownload
};

@class BaseRequest;
@protocol AFMultipartFormData;
// 成功或者失败      block
typedef void(^YMRequestCompletionBlock)(__kindof BaseRequest *request);
// 文件表单         block
typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
// 上传或者下载的进度 block
typedef void (^AFURLSessionTaskProgressBlock)(NSProgress *progress);

@interface BaseRequest : NSObject

#pragma mark - block
// success block
@property (nonatomic, copy, nullable) YMRequestCompletionBlock successCompletionBlock;
// failure block
@property (nonatomic, copy, nullable) YMRequestCompletionBlock failureCompletionBlock;
// 文件表单  block
@property (nonatomic, copy, nullable) AFConstructingBlock constructingBodyBlock;
// 上传进度  block
@property (nonatomic, copy, nullable) AFURLSessionTaskProgressBlock uploadProgressBlock;
// 下载进度  block
@property (nonatomic, copy, nullable) AFURLSessionTaskProgressBlock downloadProgressBlock;

#pragma mark - response
//  请求task
@property (nonatomic, strong) NSURLSessionTask *requestTask;
//  == requestRequest.currentRequest
@property (nonatomic, strong, readonly) NSURLRequest *currentRequest;
//  == requestRequest.originalRequest
@property (nonatomic, strong, readonly) NSURLRequest *originalRequest;
//  == requestTask.response
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;
//  == response.statusCode
@property (nonatomic, readonly) NSInteger responseStatusCode;
//  The response header fields.
@property (nonatomic, strong, nullable) NSDictionary *responseHeaders;
//  The raw data representation of response. Note this value can be nil if request failed.
@property (nonatomic, strong, nullable) NSData *responseData;
//  The string representation of response. Note this value can be nil if request failed.
@property (nonatomic, strong, nullable) NSString *responseString;
//
@property (nonatomic, strong, nullable) id responseObject;
//
@property (nonatomic, strong, nullable) id responseJSONObject;
//
@property (nonatomic, strong, nullable) NSError *error;


#pragma mark - request
// baseUrl 优先用这儿的baseUrl 再用config 的baseUrl
@property (nonatomic, strong) NSString *baseUrl;
// 请求URL  like "/aa/bb"
@property (nonatomic, strong) NSString *requestUrl;
// 请求超时 时间  默认20s
@property (nonatomic)         NSTimeInterval requestTimeoutInterval;
// 请求参数  默认nil
@property (nonatomic, strong,nullable) NSDictionary *requestArgument;
// 请求方式  默认get
@property (nonatomic, assign) YMRequestMethod requestMethod;
// 请求的头  默认nil
@property (nonatomic, strong,nullable) NSDictionary *requestHeaderField;
// 下载文件的路径   如果没有 filePath = downLoadFilePath + url.lastPathComponent
@property (nonatomic, strong,) NSString *downLoadFilePath;

#pragma mark -
+ (instancetype)new  NS_UNAVAILABLE;
// 开始请求
- (void)startWithCompletionBlockWithSuccess:(nullable YMRequestCompletionBlock)success
                                    failure:(nullable YMRequestCompletionBlock)failure;
// 上传文件
- (void)uploadFileWithprogressBlock:(nullable AFURLSessionTaskProgressBlock)progress
                            success:(nullable YMRequestCompletionBlock)success
                            failure:(nullable YMRequestCompletionBlock)failure;
// 下载文件
- (void)downloadWithBlock:(nullable AFURLSessionTaskProgressBlock)progress
                  success:(nullable YMRequestCompletionBlock)success
                  failure:(nullable YMRequestCompletionBlock)failure;
// 取消
- (void)cancel;

- (void)clearCompletionBlock;

@end
NS_ASSUME_NONNULL_END

