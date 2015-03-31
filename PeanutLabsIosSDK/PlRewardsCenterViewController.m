//
//  PlRewardsCenterViewController.m
//
//  Created by Peanut Labs Inc on 1/10/15.
//  Copyright (c) 2015 PeanutLabs. All rights reserved.
//

#import "PlRewardsCenterViewController.h"
#import "PeanutLabsManager.h"

@interface PlRewardsCenterViewController ()

@end

@implementation PlRewardsCenterViewController

- (void)loadView {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    self.plWebView = [[PlRewardsCenterView alloc] initWithFrame:CGRectZero];
    
    NSString *userId = [[PeanutLabsManager getInstance] userId];
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@", @"https://www.peanutlabs.com/userGreeting.php?userId=", userId];
    
    [self.plWebView setBaseUrl:url];
    self.view = self.plWebView;
    self.plWebView.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver: self
        selector: @selector(orientationDidChange:)
         name: UIApplicationDidChangeStatusBarOrientationNotification
           object: nil];
    
}

- (void) orientationDidChange: (NSNotification *) note
{
    [self.plWebView resizeRewardsCenterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)shouldAutorotate {
    return YES;
}


- (void)PlRewardsCenter:(PlRewardsCenterView *)plRewardsCenter donePushed:(id)sender {
    [self.delegate closeRewardsCenter];
    [self dismissViewControllerAnimated:NO completion:nil];
}


/*!
 @to-do: Make it configurable
 */
-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations {
    if (IS_PHONE_DEVICE()) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}

@end
