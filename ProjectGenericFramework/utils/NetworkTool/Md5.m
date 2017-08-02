//
//  Md5.m
//  ParentCtrlApp4iPhone
//
//  Created by 王 军 on 14-8-26.
//  Copyright (c) 2014年 Marshal Wu. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "Md5.h"

@implementation Md5
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString
{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}
@end
