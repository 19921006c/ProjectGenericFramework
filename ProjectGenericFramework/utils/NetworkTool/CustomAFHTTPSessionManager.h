//
//  CustomAFHTTPSessionManager.h
//  ProjectGenericFramework
//
//  Created by joe on 2017/8/2.
//  Copyright © 2017年 joe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomAFHTTPSessionManager : NSObject


/**
 请求成功block

 @param json 参数
 */
typedef void(^successBlock)(id json);

/**
 请求失败block

 @param error error参数
 */
typedef void(^failureBlock)(NSError *error);


/**
 获取单利

 @return 返回manager
 */
+ (instancetype)manager;


/**
 获取rsa key
 */
+ (NSString *)getRsaKey;


/**
 post 请求

 @param URLString url 字符串
 @param parameters 参数
 @param success 成功回调
 @param failure 失败
 */
- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *, id))success
     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;


- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)UpLoadImage:(NSArray *)imageArray callBack:(void(^)(NSDictionary *))callBack;
- (void)UpLoadMedicalImage:(NSArray *)imageArray callBack:(void(^)(NSDictionary *))callBack;

@end
