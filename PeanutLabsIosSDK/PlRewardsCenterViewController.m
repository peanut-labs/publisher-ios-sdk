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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    PlRewardsCenterView *plWebView = [[PlRewardsCenterView alloc] initWithFrame:CGRectZero];
    self.plWebView = plWebView;
    
    PeanutLabsManager *manager = [PeanutLabsManager getInstance];
    [self.plWebView setBaseUrl:[manager generateWelcomeUrl]];
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

- (void) orientationDidChange: (NSNotification *) note {
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
