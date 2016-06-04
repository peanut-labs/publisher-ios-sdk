//
//  PlRewardsCenterView.m
//
//  Created by Peanut Labs Inc on 1/10/15.
//  Copyright (c) 2015 PeanutLabs. All rights reserved.
//

#import "PlRewardsCenterView.h"
#import "PlUtils.h"


@implementation PlRewardsCenterView  {
    NSString *fragment;
}

- (void)resizeRewardsCenterView {
    CGRect oldFrame;
    CGRect newFrame;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat height = screenRect.size.height;
    CGFloat width = screenRect.size.width;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (SYSTEM_VERSION_LESS_THAN(@"8.0") && UIDeviceOrientationIsLandscape(orientation)) {
        CGFloat t = width;
        width = height;
        height = t;
    }
    
    oldFrame = self.containerView.frame;
    newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, width, height);
    [self.containerView setFrame:newFrame];
    
    oldFrame = self.overlay.frame;
    newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, width, height);
    [self.overlay setFrame:newFrame];
    
    if (self.activityIndicator != nil) {
        self.activityIndicator.center = CGPointMake(width / 2.0, height / 2.0);
    }
    
    float navBarHeight = 44.0;
    
    oldFrame = self.navBar.frame;
    newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, width, navBarHeight);
    [self.navBar setFrame:newFrame];

    oldFrame = self.iframeView.frame;
    newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, width, height - navBarHeight);
    [self.iframeView setFrame:newFrame];
}


- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.containerView == nil) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat height = screenRect.size.height;
        CGFloat width = screenRect.size.width;
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (SYSTEM_VERSION_LESS_THAN(@"8.0") && UIDeviceOrientationIsLandscape(orientation)) {
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
    
    //Overlay
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.overlay.backgroundColor = [UIColor whiteColor];
    self.overlay.opaque = YES;
    self.overlay.alpha = 0.4;
}


/**
    Builds the web view which hosts the userGreeting (survey / offer listing) page 
 
    @return UIWebView
 */
- (UIWebView *)buildIframeWebView:(float)y width:(float)width height:(float)height {
    self.iframeView = [[UIWebView alloc] initWithFrame:CGRectMake(0, y, width, height - y)];
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
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.translucent = true;
    
    return self.navBar;
}


- (void)setupNavBarButtons {
    
    //Done Button
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:@selector(doneButtonPushed:)];
    self.doneButton.enabled = YES;
    self.doneButton.imageInsets = UIEdgeInsetsZero;
    
    //Arrow that return you back to main app
    self.arrowButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:nil action:@selector(doneButtonPushed:)];
    self.arrowButton.enabled = YES;
    
    //Rewards Center Button
    self.rewardsCenterButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:nil action:@selector(backToRewardsCenter:)];
    self.rewardsCenterButton.enabled = YES;
    
    //Flexible Space
    self.flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.flex.enabled = YES;
    self.flex.imageInsets = UIEdgeInsetsZero;
    self.flex.style = UIBarButtonItemStylePlain;
    self.flex.tag = 0;
    self.flex.width = 0.0;
    
    //Fixed Space
    self.fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.fixed.width = 16.0f;
    
    //Back button for the webview
    self.backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:nil action:@selector(goBack:)];
    self.backButton.enabled = YES;
    
    //Forward button for the webview
    self.forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:self action:@selector(goForward:)];
    self.forwardButton.enabled = YES;
    self.forwardButton.imageInsets = UIEdgeInsetsZero;
   
    
    //Toolbar title
    self.toolbarTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.toolbarTitleLabel.text = @"Peanut Labs";
    [self.toolbarTitleLabel sizeToFit];
    self.toolbarTitleLabel.backgroundColor = [UIColor clearColor];
    self.toolbarTitleLabel.textColor = [UIColor blackColor];
    self.toolbarTitleLabel.textAlignment = NSTextAlignmentCenter;
    
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
    [self.iframeView addSubview:self.overlay];
}


- (void)hideLoadingIndicator {
    [self.activityIndicator stopAnimating];
    [self.overlay removeFromSuperview];
}


#pragma mark - Delegate Methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSArray *fragments = [NSArray arrayWithObjects:@"offer", @"survey", @"open", nil];

    if ([request.URL.host isEqualToString:@"www.peanutlabs.com"] || [request.URL.host isEqualToString:@"peanutlabs.com"]) {
        if ([fragments containsObject:[request.URL fragment]]) {

            fragment = [request.URL fragment] ;
            [self updateNavBarHeight:YES];

            return NO;
        } else if ([[request.URL fragment] isEqualToString:@"close"] || [[request.URL fragment] isEqualToString:@""]) {
            
            fragment = nil;
            [self updateNavBarHeight:NO];
            
            return NO;
        } else if ([[request.URL.path lastPathComponent] isEqualToString:@"landingPage.php"]) {
            
            [self updateNavBarHeight:YES];
        } else if ([request.URL.path isEqualToString:@"/userGreeting.php"]) {
        
            NSArray *urlComponents = [request.URL.query componentsSeparatedByString:@"&"];
            
            if (![urlComponents containsObject:@"mobile_sdk=true"]) {
                [self updateNavBarHeight:NO];
                
                NSLocale *locale = [NSLocale currentLocale];
                NSString *cc = [locale objectForKey:NSLocaleLanguageCode];
                NSString *zl_locale = [NSString stringWithFormat:@"%@%@", @"zl=", cc];
                NSURL *url = [NSURL URLWithString:self.baseUrl];
                
                if (![urlComponents containsObject:zl_locale]) {
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",request.URL, @"&mobile_sdk=true&ref=ios_sdk"]];
                }
                
                
                NSURLRequest* request = [NSURLRequest requestWithURL:url];
                [self.iframeView loadRequest:request];
                
                return NO;
            }
        }
    }
    
    [self showLoadingIndicator];
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *host = [self.iframeView.request.URL host];
    NSString *path = [self.iframeView.request.URL path];
    NSString *title = @"Peanut Labs";
    
    if ([fragment isEqualToString:@"offer"] || [fragment isEqualToString:@"survey"]) {
        title = [fragment capitalizedString];
    }
    
    self.toolbarTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.toolbarTitleLabel.backgroundColor = [UIColor clearColor];
    self.toolbarTitleLabel.textColor = [UIColor blackColor];
    self.toolbarTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.toolbarTitleLabel.text = title;
    [self.toolbarTitleLabel sizeToFit];
    
    self.toolbarTitle = [[UIBarButtonItem alloc] initWithCustomView:self.toolbarTitleLabel];

    if ([host isEqualToString:@"www.peanutlabs.com"] || [host isEqualToString:@"peanutlabs.com"]) {
        if ([path isEqualToString:@"/userGreeting.php"]) {
            self.navBar.items = [NSArray arrayWithObjects: self.arrowButton, self.doneButton, nil];
        } else {
            self.navBar.items = [NSArray arrayWithObjects:self.flex, self.toolbarTitle, self.flex, self.rewardsCenterButton, nil];
        }
    } else {
        [self updateNavBarHeight:NO];
        self.navBar.items = [NSArray arrayWithObjects:self.backButton, self.fixed, self.forwardButton, self.flex, self.toolbarTitle, self.flex, self.rewardsCenterButton, nil];
    }
    
    [self.backButton setEnabled:[self.iframeView canGoBack]];
    [self.forwardButton setEnabled:[self.iframeView canGoForward]];
    
    [self hideLoadingIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.navBar.items = [NSArray arrayWithObjects: self.arrowButton, self.doneButton, nil];
    [self hideLoadingIndicator];
}

- (void)updateNavBarHeight: (BOOL) hide {

    CGRect frame = CGRectNull;
    float navBarHeight = 0;
    if (hide) {
        frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } else {
        navBarHeight = 44.0;
        frame = CGRectMake(0, 44.0, self.frame.size.width, self.frame.size.height - navBarHeight);
    }
    
    self.navBar.frame = CGRectMake(0, 0, self.frame.size.width, navBarHeight);
    self.iframeView.frame = frame;
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
