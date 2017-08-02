//
//  NetWorkAgent.m
//  ProjectGenericFramework
//
//  Created by joe on 2017/8/2.
//  Copyright © 2017年 joe. All rights reserved.
//

#import "NetWorkAgent.h"
#import "NetWorkConfig.h"
#import "BaseRequest.h"
#import <pthread/pthread.h>
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

@implementation NetWorkAgent{
    AFHTTPSessionManager *_manager;
    NetWorkConfig *_config;
    dispatch_queue_t _processingQueue;
    //请求记录  字典
    NSMutableDictionary<NSNumber *, BaseRequest *> *_requestsRecord;
    
    pthread_mutex_t _lock;
}

+ (NetWorkAgent *)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //网络配置文件
        _config = [NetWorkConfig sharedInstance];
        _manager = [AFHTTPSessionManager manager];
        //生成一个并发执行队列，block被分发到多个线程去执行
        _processingQueue = dispatch_queue_create("com.yimai.network.processing", DISPATCH_QUEUE_CONCURRENT);
        pthread_mutex_init(&_lock, NULL);
        //安全模式
        _manager.securityPolicy = _config.securityPolicy;
        //修改block的线程 默认在主线程
        _manager.completionQueue = _processingQueue;
        _requestsRecord = [NSMutableDictionary dictionary];
        // manger的response 返回格式默认是json，request的请求格式默认是二进制
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil];
    }
    return self;
}


- (NSURLSessionTask *)sessionTaskForRequest:(BaseRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
    YMRequestMethod method = [request requestMethod];
    NSString *url = [self generateUrl:request];
    NSDictionary  *param = [self generatepParams:request];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    AFConstructingBlock constructingBlock = request.constructingBodyBlock;
    switch (method) {
        case YMRequestMethodGET:
            return [self dataTaskWithHTTPMethod:@"GET" requestSerializer:requestSerializer URLString:url parameters:param constructingBodyWithBlock:nil error:error];
        case YMRequestMethodPOST:
            return [self dataTaskWithHTTPMethod:@"POST" requestSerializer:requestSerializer URLString:url parameters:param constructingBodyWithBlock:nil error:error];
        case YMRequestMethodHEAD:
            return [self dataTaskWithHTTPMethod:@"HEAD" requestSerializer:requestSerializer URLString:url parameters:param constructingBodyWithBlock:nil error:error];
        case YMRequestMethodPUT:
            return [self dataTaskWithHTTPMethod:@"PUT" requestSerializer:requestSerializer URLString:url parameters:param constructingBodyWithBlock:nil error:error];
        case YMRequestMethodDELETE:
            return [self dataTaskWithHTTPMethod:@"DELETE" requestSerializer:requestSerializer URLString:url parameters:param constructingBodyWithBlock:nil error:error];
        case YMRequestMethodUpload:
            return [self uploadTaskWithRequest:request HTTPMethod:@"POST" requestSerializer:requestSerializer URLString:url parameters:param constructingBodyWithBlock:constructingBlock error:error];
        case YMRequestMethodDownload:
            return [self downloadTaskWithRequest:request HTTPMethod:@"GET" requestSerializer:requestSerializer URLString:url parameters:param constructingBodyWithBlock:constructingBlock error:error];
            return nil;
    }
}

// 下载Task
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(BaseRequest *)ymBaseRequest
                                           HTTPMethod:(NSString *)method
                                    requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                            URLString:(NSString *)URLString
                                           parameters:(id)parameters
                            constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                                error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *request = nil;
    request = [requestSerializer requestWithMethod:@"GET" URLString:URLString parameters:parameters error:error];
    __block NSURLSessionDownloadTask *dataTask = nil;
    NSString *downloadTargetPath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:ymBaseRequest.downLoadFilePath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    if (isDirectory) {
        NSString *fileName = [URLString lastPathComponent];
        downloadTargetPath = [NSString pathWithComponents:@[ymBaseRequest.downLoadFilePath, fileName]];
    } else {
        downloadTargetPath = ymBaseRequest.downLoadFilePath;
    }
    dataTask = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (ymBaseRequest.downloadProgressBlock) {
                ymBaseRequest.downloadProgressBlock(downloadProgress);
            }
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable _error) {
        [self handleRequestResult:dataTask responseObject:filePath error:_error];
    }];
    return dataTask;
}



// 上传Task
- (NSURLSessionDataTask *)uploadTaskWithRequest:(BaseRequest *)ymBaseRequest
                                     HTTPMethod:(NSString *)method
                              requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                      URLString:(NSString *)URLString
                                     parameters:(id)parameters
                      constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                          error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *request = nil;
    
    if (block) {
        request = [requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:error];
    } else {
        request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    }
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (ymBaseRequest.uploadProgressBlock) {
                ymBaseRequest.uploadProgressBlock(uploadProgress);
            }
        });
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable _error) {
        [self handleRequestResult:dataTask responseObject:responseObject error:_error];
    }];
    return dataTask;
}

// NSURLSessionDataTask
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                       constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                           error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *request = nil;
    
    if (block) {
        request = [requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:error];
    } else {
        request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    }
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_manager dataTaskWithRequest:request
                           completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *_error) {
                               [self handleRequestResult:dataTask responseObject:responseObject error:_error];
                           }];
    
    return dataTask;
}



- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error {
    Lock();
    BaseRequest *request = _requestsRecord[@(task.taskIdentifier)];
    Unlock();
    if (!request) {
        return;
    }
    
    NSLog(@"Finished Request: %@", NSStringFromClass([request class]));
    
    NSError * __autoreleasing serializationError = nil;
    
    
    NSError *requestError = nil;
    BOOL succeed = YES;
    
    request.responseObject = responseObject;
    if (error) {
        succeed = NO;
        requestError = error;
        request.error = requestError;
    } else if (serializationError) {
        succeed = NO;
        requestError = serializationError;
        request.error = requestError;
    }
    if (succeed) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (request.successCompletionBlock) {
                request.successCompletionBlock(request);
            }
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (request.failureCompletionBlock) {
                request.failureCompletionBlock(request);
            }
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeRequestFromRecord:request];
        [request clearCompletionBlock];
    });
}


//  生成请求url
- (NSString *)generateUrl:(BaseRequest *)request
{
    NSString *requestUrl = request.requestUrl;
    NSURL *temp = [NSURL URLWithString:requestUrl];
    // requestUrl 可以用
    if (temp && temp.host && temp.scheme) {
        return requestUrl;
    }
    NSString *baseUrl;
    if (request.baseUrl.length > 0) {//有就用request的
        baseUrl = request.baseUrl;
    }else{
        baseUrl = _config.baseUrl;
    }
    return [NSURL URLWithString:requestUrl relativeToURL:[NSURL URLWithString:baseUrl]].absoluteString;
}
// 生成请求参数
- (NSDictionary *)generatepParams:(BaseRequest *)request
{
    NSDictionary *additionalArguments  = _config.additionalArguments;
    NSDictionary *orginArguments = request.requestArgument;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:orginArguments];
    [params addEntriesFromDictionary:additionalArguments];
    return params;
}
// 生成request的请求格式 ，目的为了 设置header
- (AFHTTPRequestSerializer *)requestSerializerForRequest:(BaseRequest *)request {
    //默认是二进制请求
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    // 设置 HTTPHeaderField
    NSDictionary<NSString *, NSString *> *headerFieldValueDictionary = [request requestHeaderField];
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    //设置语言
    [requestSerializer setValue:currentLanguage forHTTPHeaderField:@"Accept-Language"];
    return requestSerializer;
}



- (void)addRequest:(BaseRequest *)request
{
    NSError * __autoreleasing requestSerializationError = nil;
    request.requestTask = [self sessionTaskForRequest:request error:&requestSerializationError];
    [self addRequestToRecord:request];
    [request.requestTask resume];
}


- (void)removeRequest:(BaseRequest *)request{
    [request.requestTask cancel];
    [self removeRequestFromRecord:request];
    [request clearCompletionBlock];
}


- (void)addRequestToRecord:(BaseRequest *)request {
    if (request.requestTask != nil) {
        Lock();
        _requestsRecord[@(request.requestTask.taskIdentifier)] = request;
        Unlock();
    }
}

- (void)removeRequestFromRecord:(BaseRequest *)request {
    Lock();
    [_requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
    NSLog(@"Request queue size = %zd", [_requestsRecord count]);
    Unlock();
}

@end
