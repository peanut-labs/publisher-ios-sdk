//
//  PlRewardsCenterView.h
//
//  Created by Peanut Labs Inc on 1/10/15.
//  Copyright (c) 2015 PeanutLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlRewardsCenterView;

@protocol PlRewardsCenterDelegate<NSObject>

- (void)PlRewardsCenter:(PlRewardsCenterView * _Nonnull)plRewardsCenter donePushed:(id _Nonnull)sender;

@end

@interface PlRewardsCenterView : UIView <UIWebViewDelegate>

@property NSString *baseUrl;

@property (strong, nonatomic, nullable) IBOutlet UIView *containerView;
@property (strong, nonatomic, nullable) IBOutlet UIToolbar *navBar;
@property (strong, nonatomic, nullable) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic, nullable) IBOutlet UIBarButtonItem *arrowButton;
@property (strong, nonatomic, nullable) IBOutlet UIBarButtonItem *rewardsCenterButton;
@property (strong, nonatomic, nullable) IBOutlet UIBarButtonItem *flex;
@property (strong, nonatomic, nullable) IBOutlet UIBarButtonItem *fixed;
@property (strong, nonatomic, nullable) IBOutlet UIBarButtonItem *toolbarTitle;
@property (strong, nonatomic, nullable) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic, nullable) IBOutlet UIBarButtonItem *forwardButton;
@property (strong, nonatomic, nullable) IBOutlet UILabel *toolbarTitleLabel;
@property (weak, nonatomic, nullable) IBOutlet UIWebView *iframeView;
@property (strong, nonatomic, nullable) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic, nullable) IBOutlet UIView *overlay;

@property (weak, nonatomic, nullable) id<PlRewardsCenterDelegate> delegate;

- (UIToolbar * _Nonnull)buildNavBarWithY:(float)y width:(float)width height:(float)height;
- (void)setupNavBarButtons;
- (void)resizeRewardsCenterView;

@end
