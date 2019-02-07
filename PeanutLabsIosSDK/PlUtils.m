//
//  PlUtils.m
//
//  Created by Peanut Labs Inc on 1/10/15.
//  Copyright (c) 2015 PeanutLabs. All rights reserved.
//

#import "PlUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation PlUtils

+ (NSString *) md5:(NSString *) s {
    const char *cStr = [s UTF8String];
    unsigned char res[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), res);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [result appendFormat:@"%02x", res[i]];
    }
    return [NSString stringWithString:result];
}

@end
