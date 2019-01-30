//
//  PeanutLabsManager.h
//
//  Created by Peanut Labs Inc on 1/10/15.
//  Copyright (c) 2015 PeanutLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlRewardsCenterViewController.h"
#import "PlUtils.h"

@class PeanutLabsManager;

@protocol PeanutLabsManagerDelegate

@required
- (void)peanutLabsManager:( PeanutLabsManager * _Nonnull )peanutlabsManager rewardsCenterDidOpen:( NSString * _Nonnull )userId;
- (void)peanutLabsManager:( PeanutLabsManager * _Nonnull )peanutlabsManager rewardsCenterDidClose:( NSString * _Nonnull )userId;

@end

@interface PeanutLabsManager : NSObject <PlRewardsCenterViewControllerDelegate>

@property (nonatomic, assign) int appId;
@property (nonatomic, strong, nullable) NSString *appKey;
@property (nonatomic, strong, nullable) NSString *endUserId;
@property (nonatomic, strong, nullable) NSString *userId;
@property (nonatomic, strong, nullable) NSString *dob;
@property (nonatomic, strong, nullable) NSString *sex;
@property (nonatomic, strong, nullable) NSString *publisherName;
@property (nonatomic, strong, nullable) NSString *programId;

+ (PeanutLabsManager* _Nonnull)getInstance;

- (void)openRewardsCenter;
- (NSString * _Nonnull)generateUserId;
- (NSString * _Nonnull)generateWelcomeUrl;
- (void)addCustomParameter: (NSString * _Nonnull)key value:(NSString * _Nonnull) value;
- (NSMutableDictionary * _Nonnull)getCustomVars;
- (void) clearCustomParameters;

@property (weak, nonatomic, nullable) id<PeanutLabsManagerDelegate> delegate;

@end
