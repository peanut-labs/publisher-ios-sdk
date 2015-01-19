//
//  PlRewardsCenterView.m
//
//  Created by Peanut Labs Inc on 1/10/15.
//  Copyright (c) 2015 PeanutLabs. All rights reserved.
//

#import "PlRewardsCenterView.h"
#import <QuartzCore/QuartzCore.h>


@implementation PlRewardsCenterView

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.containerView == nil) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat height = screenRect.size.height;
        CGFloat width = screenRect.size.width;
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIDeviceOrientationIsLandscape(orientation)) {
            CGFloat t = width;
            width = height;
            height = t;
        }
        
        [self buildContainerViewWithWidth:width andHeight:height];
        
        if (self.baseUrl) {
            NSURL *url = [NSURL URLWithString:self.baseUrl];
            NSURLRequest* request = [NSURLRequest requestWithURL:url];
            [self.iframeView loadRequest:request];
        }
    }
    
    [self addSubview:self.containerView];
}


/**
    Builds the main view with the specified width and height
 
    @param width Screen width
    @param height Screen height
 */
- (void)buildContainerViewWithWidth:(float)width andHeight:(float)height {
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, height)];
    self.containerView.userInteractionEnabled = YES;
    
    float navBarHeight = 44.0;
    [self.containerView addSubview:[self buildNavBarWithY:0 width:width height:navBarHeight]];
    [self setupNavBarButtons];
    [self.containerView addSubview:[self buildIframeWebView:navBarHeight width:width height:height]];
}


/**
    Builds the web view which hosts the userGreeting (survey / offer listing) page 
 
    @return UIWebView
 */
- (UIWebView *)buildIframeWebView:(float)y width:(float)width height:(float)height {
    self.iframeView = [[UIWebView alloc] initWithFrame:CGRectMake(0, y, width, height)];
    self.iframeView.userInteractionEnabled = YES;
    self.iframeView.delegate = self;
    
    [[self.iframeView scrollView] setBounces:YES];
    [self.iframeView setScalesPageToFit:YES];
    
    return self.iframeView;
}


/**
    Builds the navigation bar for the Rewards Center

 */
- (UIToolbar *)buildNavBarWithY:(float)y width:(float)width height:(float)height {
    self.navBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, y, width, height)];
    self.navBar.userInteractionEnabled = YES;
    self.navBar.opaque = NO;
    self.navBar.alpha = 1.000;
    self.navBar.autoresizesSubviews = YES;
    self.navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.navBar.barStyle = UIBarStyleDefault;
    self.navBar.clearsContextBeforeDrawing = NO;
    self.navBar.clipsToBounds = NO;
    self.navBar.contentMode = UIViewContentModeScaleToFill;
    self.navBar.frame = CGRectMake(0.0, 0.0, width, 44.0);
    self.navBar.hidden = NO;
    self.navBar.multipleTouchEnabled = NO;
    self.navBar.tag = 0;
    
    return self.navBar;
}


- (void)setupNavBarButtons {
    //Done Button
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:nil action:nil];
    self.doneButton.enabled = YES;
    self.doneButton.imageInsets = UIEdgeInsetsZero;
    self.doneButton.style = UIBarButtonItemStylePlain;
    self.doneButton.action = @selector(doneButtonPushed:);
    
    //Rewards Center Button
    self.rewardsCenterButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    self.rewardsCenterButton.enabled = YES;
    self.rewardsCenterButton.imageInsets = UIEdgeInsetsZero;
    self.rewardsCenterButton.style = UIBarButtonItemStylePlain;
    self.rewardsCenterButton.action = @selector(backToRewardsCenter:);
    
    //Flexible Space
    self.flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.flex.enabled = YES;
    self.flex.imageInsets = UIEdgeInsetsZero;
    self.flex.style = UIBarButtonItemStylePlain;
    self.flex.tag = 0;
    self.flex.width = 0.0;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(goBack:)];
    backItem.imageInsets = UIEdgeInsetsZero;
    
    UIToolbar *backToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backToolbar.userInteractionEnabled = YES;
    [backToolbar setTransform:CGAffineTransformMakeScale(-1, 1)];
    backToolbar.items = [NSArray arrayWithObjects:backItem, nil];
    backToolbar.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    
    self.backButton = [[UIBarButtonItem alloc] initWithCustomView:backToolbar];
    self.backButton.enabled = YES;
    self.backButton.imageInsets = UIEdgeInsetsZero;
    
    //Forward button for the webview
    self.forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(goForward:)];
    self.forwardButton.enabled = YES;
    self.forwardButton.imageInsets = UIEdgeInsetsZero;
   
    
    //Toolbar title
    self.toolbarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 23)];
    self.toolbarTitleLabel.text = @"Peanut Labs";
    
    //Toolbar
    self.toolbarTitle = [[UIBarButtonItem alloc] initWithCustomView:self.toolbarTitleLabel];
}


- (void)showLoadingIndicator {
    if (self.activityIndicator == nil) {
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        self.activityIndicator.layer.cornerRadius = 05;
        self.activityIndicator.opaque = NO;
        self.activityIndicator.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.activityIndicator setColor:[UIColor colorWithRed:0.6 green:0.8 blue:1.0 alpha:1.0]];
        [self.containerView addSubview: self.activityIndicator];
    }
    [self.activityIndicator startAnimating];
}


- (void)hideLoadingIndicator {
    [self.activityIndicator stopAnimating];
}


#pragma mark - Delegate Methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self showLoadingIndicator];
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *host = [self.iframeView.request.URL host];
    if ([host isEqualToString:@"www.peanutlabs.com"] || [host isEqualToString:@"peanutlabs.com"]) {
        self.navBar.items = [NSArray arrayWithObjects:self.doneButton, self.flex, self.toolbarTitle, self.flex, nil];
    } else {
        self.navBar.items = [NSArray arrayWithObjects:self.backButton, self.forwardButton, self.flex, self.toolbarTitle, self.flex, self.rewardsCenterButton, nil];
    }
    
    [self.backButton setEnabled:[self.iframeView canGoBack]];
    [self.forwardButton setEnabled:[self.iframeView canGoForward]];
    
    [self hideLoadingIndicator];
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connectivity Error" message:@"Please ensure you are connected to the internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    self.navBar.items = [NSArray arrayWithObjects:self.doneButton, self.flex, self.toolbarTitle, self.flex, nil];
    [self hideLoadingIndicator];
}



#pragma mark - Actions
- (IBAction)doneButtonPushed:(id)sender {
    [self.delegate PlRewardsCenter:self donePushed:sender];
}


- (IBAction)backToRewardsCenter:(id)sender {
    NSURL *url = [NSURL URLWithString:self.baseUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.iframeView loadRequest:request];
}


- (IBAction)goBack:(id)sender {
    [self.iframeView goBack];
}

- (IBAction)goForward:(id)sender {
    [self.iframeView goForward];
}


@end
