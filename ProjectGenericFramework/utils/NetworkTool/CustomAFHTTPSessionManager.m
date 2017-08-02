//
//  CustomAFHTTPSessionManager.m
//  ProjectGenericFramework
//
//  Created by joe on 2017/8/2.
//  Copyright © 2017年 joe. All rights reserved.
//
#define kTokenInvalid @"kTokenInvalid"
#define kTmpUserId @""
//http 添加头
#define AFHttpHeadKey   @"Yimai-Request"
//RSA公钥
#define RSAPUBLICKEY @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4QVQ+n54HCCFMHuGikTD0GMDxHgB8utMoszl955dcl6ax5YOMTa1z4Ib815/PGbRCBDv0vsG9jeGKY1pe9Qj3KHxJKiicJr3KV1R1vmzv1JdcRNTFVb6I9/awbJTNnTOvl8JZNm8QomdHlrQk8u3vP/Xdj217Mk4I4mTGDK1WFwIDAQAB\n-----END PUBLIC KEY-----"
#define AFUDIDKey       @"Yimai-Code"
//推送注册id
#define JPushRegistrationID @"JPushRegistrationID"


#import "CustomAFHTTPSessionManager.h"

#import "URL.h"
//#import "UserInfo.h"
#import <ImageIO/ImageIO.h>
#import "RSA.h"
#import "Md5.h"
#import <sys/sysctl.h>
#import "BaseRequest.h"
#import "AFNetworking.h"

static CustomAFHTTPSessionManager *manager = nil;
@implementation CustomAFHTTPSessionManager

+ (instancetype)manager{
    if (!manager) {
        manager = [[self alloc]init];
    }
    return manager;
}

//post
- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *, id))success
     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    BaseRequest *request = [[BaseRequest alloc]init];
    request.requestUrl = URLString;
    request.requestArgument = parameters;
    request.requestMethod = YMRequestMethodPOST;
    //    request.requestHeaderField  = @{AFHttpHeadKey:[RSA encryptString:[CustomAFHTTPSessionManager getRsaKey] publicKey:RSAPUBLICKEY],
    //                                    AFUDIDKey:[[UIDevice currentDevice].identifierForVendor UUIDString]};
    [request startWithCompletionBlockWithSuccess:^(__kindof BaseRequest * _Nonnull request) {
        if ([request.responseObject[@"code"] intValue] == 40000||
            [request.responseObject[@"code"] intValue] == 40001) {//token 失效
            NSString *msg = request.responseObject[@"msg"];
            [[NSNotificationCenter defaultCenter]postNotificationName:kTokenInvalid object:@{@"msg":msg}];
            return ;
        }
        success(nil,request.responseObject);
    } failure:^(__kindof BaseRequest * _Nonnull request) {
        failure(nil,request.error);
    }];
}
//get请求
- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    BaseRequest *request = [[BaseRequest alloc]init];
    request.requestUrl = URLString;
    request.requestArgument = parameters;
    request.requestMethod = YMRequestMethodGET;
    [request startWithCompletionBlockWithSuccess:^(__kindof BaseRequest * _Nonnull request) {
        if ([request.responseObject[@"code"] intValue] == 40000||
            [request.responseObject[@"code"] intValue] == 40001) {//token 失效
            NSString *msg = request.responseObject[@"msg"];
            [[NSNotificationCenter defaultCenter]postNotificationName:kTokenInvalid object:@{@"msg":msg}];
            return ;
        }
        success(nil,request.responseObject);
    } failure:^(__kindof BaseRequest * _Nonnull request) {
        failure(nil,request.error);
    }];
}


//上传图片
- (void)UpLoadImage:(NSArray *)imageArray callBack:(void(^)(NSDictionary *))callBack
{
    if (imageArray == nil) {
        callBack(nil);
    }
    NSString *sign =  [Md5 getMd5_32Bit_String:[kTmpUserId stringByAppendingString:@"9ab41cc1bbef27fa4b5b7d4cbe17a75a"]];
    NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)imageArray.count];
    NSDictionary *parameters = @{@"command": @"imgload",
                                 @"userid":kTmpUserId ,
                                 @"sign":sign,
                                 @"count":count};
    BaseRequest *request = [[BaseRequest alloc]init];
    request.baseUrl = @"http://api.club.xywy.com/doctorApp.interface.php";
    request.requestUrl = @"";
    request.requestArgument = parameters;
    request.requestMethod = YMRequestMethodUpload;
    request.requestHeaderField  = @{AFHttpHeadKey:[RSA encryptString:[CustomAFHTTPSessionManager getRsaKey] publicKey:RSAPUBLICKEY],
                                    AFUDIDKey:[[UIDevice currentDevice].identifierForVendor UUIDString]};
    request.constructingBodyBlock = ^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < imageArray.count; i++) {
            NSString *name = [NSString stringWithFormat:@"Filedata%d",i+1];
            [formData appendPartWithFileData:UIImageJPEGRepresentation([imageArray objectAtIndex:i], 0.3) name:name fileName:name mimeType:@"image/jpg"];
        }
    };
    [request uploadFileWithprogressBlock:^(NSProgress * _Nonnull progress) {
//        FLOG(@"progress---%@",progress);
    } success:^(__kindof BaseRequest * _Nonnull request) {
        callBack(request.responseObject);
    } failure:^(__kindof BaseRequest * _Nonnull request) {
        callBack(nil);
    }];
}


//上传图片  多张
- (void)UpLoadMedicalImage:(NSArray *)imageArray callBack:(void(^)(NSDictionary *))callBack
{
    if (imageArray == nil) {
        callBack(nil);
    }
    NSString *sign =  [Md5 getMd5_32Bit_String:[kTmpUserId stringByAppendingString:@"9ab41cc1bbef27fa4b5b7d4cbe17a75a"]] ;
    NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)imageArray.count];
    NSDictionary *parameters = @{@"command": @"imageUpload",
                                 @"userid":kTmpUserId ,
                                 @"sign":sign,
                                 @"count":count};
    BaseRequest *request = [[BaseRequest alloc]init];
    request.baseUrl = @"http://api.imgupload.xywy.com/upload.php?from=yixian";
    request.requestUrl = @"";
    request.requestArgument = parameters;
    request.requestMethod = YMRequestMethodUpload;
    request.requestHeaderField  = @{AFHttpHeadKey:[RSA encryptString:[CustomAFHTTPSessionManager getRsaKey] publicKey:RSAPUBLICKEY],
                                    AFUDIDKey:[[UIDevice currentDevice].identifierForVendor UUIDString]};
    request.constructingBodyBlock = ^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < imageArray.count; i++) {
            NSString *name = [NSString stringWithFormat:@"Filedata%d.jpg",i+1];
            NSData *data = UIImageJPEGRepresentation([imageArray objectAtIndex:i], 0.0);
            [formData appendPartWithFileData:data name:name fileName:name mimeType:@"image/jpg"];
            data = nil;
        }
    };
    [request uploadFileWithprogressBlock:^(NSProgress * _Nonnull progress) {
//        FLOG(@"progress---%@",progress);
    } success:^(__kindof BaseRequest * _Nonnull request) {
        callBack(request.responseObject);
    } failure:^(__kindof BaseRequest * _Nonnull request) {
        callBack(nil);
    }];
}









+ (NSString *)getRsaKey{
    
    NSString *string = nil;
    if (kTmpUserId.length==0) {
        string = @"0";
        
    }else{
        string = kTmpUserId;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *registerId;
    if ([defaults objectForKey:JPushRegistrationID] == nil || [[defaults objectForKey:JPushRegistrationID] isKindOfClass:[NSNull class]]) {
        registerId = @"";
    }else{
        registerId = [defaults objectForKey:JPushRegistrationID];
    }
    NSString *str = [NSString stringWithFormat:@"%@|%@|IOS%f|%@|%@|%@",string,[CustomAFHTTPSessionManager platformString],[[UIDevice currentDevice].systemVersion floatValue],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],@"",registerId];
//    FLOG(@"HEADEEEEE======%@", str);
    return str;
}

//获取设备型号
+ (NSString *) platformString{
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
    
}
@end
