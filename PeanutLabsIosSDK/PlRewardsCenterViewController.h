//
//  PlRewardsCenterViewController.h
//
//  Created by Peanut Labs Inc on 1/10/15.
//  Copyright (c) 2015 PeanutLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlRewardsCenterView.h"

@class PlRewardsCenterViewController;

@protocol PlRewardsCenterViewControllerDelegate

- (void)closeRewardsCenter;

@end


@interface PlRewardsCenterViewController : UIViewController <PlRewardsCenterDelegate>

@property (strong, nonatomic) IBOutlet PlRewardsCenterView *plWebView;

@property (strong, nonatomic) id<PlRewardsCenterViewControllerDelegate> delegate;


@end
