//
//  PlRewardsCenterView.h
//
//  Created by Peanut Labs Inc on 1/10/15.
//  Copyright (c) 2015 PeanutLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlRewardsCenterView;

@protocol PlRewardsCenterDelegate<NSObject>

- (void)PlRewardsCenter:(PlRewardsCenterView *)plRewardsCenter donePushed:(id)sender;

@end

@interface PlRewardsCenterView : UIView <UIWebViewDelegate>

@property NSString *baseUrl;

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIToolbar *navBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *arrowButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rewardsCenterButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *flex;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *fixed;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *toolbarTitle;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (strong, nonatomic) IBOutlet UILabel *toolbarTitleLabel;
@property (strong, nonatomic) IBOutlet UIWebView *iframeView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIView *overlay;

@property (strong, nonatomic) id<PlRewardsCenterDelegate> delegate;

- (UIToolbar *)buildNavBarWithY:(float)y width:(float)width height:(float)height;
- (void)setupNavBarButtons;
- (void)resizeRewardsCenterView;

@end
