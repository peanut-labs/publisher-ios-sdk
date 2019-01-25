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

@required
- (void)closeRewardsCenter;

@end


@interface PlRewardsCenterViewController : UIViewController <PlRewardsCenterDelegate>

@property (weak, nonatomic, nullable) IBOutlet PlRewardsCenterView *plWebView;
@property (weak, nonatomic, nullable) id<PlRewardsCenterViewControllerDelegate> delegate;


@end
