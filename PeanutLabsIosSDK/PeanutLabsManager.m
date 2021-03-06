//
//  PeanutLabsManager.m
//
//  Created by Peanut Labs Inc on 1/10/15.
//  Copyright (c) 2015 PeanutLabs. All rights reserved.
//

#import "PeanutLabsManager.h"
#import "PlUtils.h"
#import "PlRewardsCenterViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface PeanutLabsManager()
@property (nonatomic, strong, nonnull) NSMutableDictionary *customVars;
@end

@implementation PeanutLabsManager

#pragma mark - getInstance
+ (PeanutLabsManager *)getInstance {
    static PeanutLabsManager *_plManagerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _plManagerInstance = [[self alloc] init];
    });
    return _plManagerInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.customVars = [NSMutableDictionary new];
    }
    return self;
}

/*
 IF you're using the generation client side, you must use transaction sec key to validate reward callbacks since app key is exposed
 */
- (NSString *)generateUserId {
    if (self.endUserId == nil) {
        [NSException raise:@"Invalid End User Id" format:@"The property endUserId must be set to generate full user id."];
    }
    
    NSString *inputString = [[NSString alloc] initWithFormat:@"%@%d%@", self.endUserId, self.appId, self.appKey];
    NSString *hash = [PlUtils md5:inputString];
    NSString *userGo = [hash substringWithRange:NSMakeRange(0, 10)];
    return [NSString stringWithFormat:@"%@-%d-%@", self.endUserId, self.appId, userGo];
}

- (NSString *)generateWelcomeUrl {
    
    NSString *userId = [_userId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@%@", @"http://www.peanutlabs.com/userGreeting.php?userId=", userId, @"&mobile_sdk=true&ref=ios_sdk"];
    NSPredicate *pred = nil;
    
    // injecting dob into url
    if (_dob) {
        
        pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]{2}-[0-9]{2}-[0-9]{4}"];
        
        if ([pred evaluateWithObject:_dob]) {
            url = [url stringByAppendingFormat:@"%@%@",  @"&dob=", _dob];
        }
    }
    
    // injecting sex into url
    if (_sex) {
        pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[1-2]$"];
        
        if ([pred evaluateWithObject:_sex]) {
            url = [url stringByAppendingFormat:@"%@%@", @"&sex=", _sex];
        }
    }
    
    if (_programId) {
        pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z0-9]*$"];
        
        if ([pred evaluateWithObject:_programId]) {
            url = [url stringByAppendingFormat:@"%@%@", @"&program=", _programId];
        }
    }
    
    // inject custom vars into url
    NSMutableDictionary *customVars = [self getCustomVars];
    int counter = 1;
    
    for (NSString *key in customVars){
        
        pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z0-9]*$"];
        
        if ([pred evaluateWithObject:key] && [pred evaluateWithObject:[customVars objectForKey:key]]) {
            url = [url stringByAppendingFormat:@"%@%d%@%@", @"&var_key_", counter, @"=", key];
            url = [url stringByAppendingFormat:@"%@%d%@%@", @"&var_val_", counter, @"=", [customVars objectForKey:key]];
        }
        counter++;
    }
    
    // injecting locale into url
    NSLocale *locale = [NSLocale currentLocale];
    NSString *cc = [locale objectForKey:NSLocaleLanguageCode];
    
    if (cc) {
        url = [url stringByAppendingFormat:@"%@%@", @"&zl=", cc];
    }
    
    return url;
}

- (void)openRewardsCenter { 
    if (self.userId == nil) {
        self.userId = [self generateUserId];
    }
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    PlRewardsCenterViewController *rewardsCenter = [[PlRewardsCenterViewController alloc] init];
    if ([rootViewController presentedViewController] == nil) {
        [rootViewController presentViewController:rewardsCenter animated:YES completion:nil];
    } else {
        [[rootViewController presentedViewController] presentViewController:rewardsCenter animated:YES completion:nil];
    }
    rewardsCenter.delegate = self;
    
    if (_delegate) {
        [_delegate peanutLabsManager:self rewardsCenterDidOpen:_userId];
    }
}

- (void)closeRewardsCenter {
    if (_delegate) {
        [_delegate peanutLabsManager:self rewardsCenterDidClose:_userId];
    }
    _userId = nil;
}

- (void)addCustomParameter: (NSString *)key value:(NSString *) value {
    [_customVars setObject:value forKey: key];
}

- (NSMutableDictionary *)getCustomVars {
    return _customVars;
}

- (void) clearCustomParameters {
    [_customVars removeAllObjects];
}

@end
