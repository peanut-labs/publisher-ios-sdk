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
    
    PeanutLabsManager *manager = [PeanutLabsManager getInstance];
    
    NSString *userId = [[manager userId] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@%@", @"http://www.peanutlabs.com/userGreeting.php?userId=", userId, @"&mobile_sdk=true&ref=ios_sdk"];
    NSPredicate *pred = nil;
    
    // injecting dob into url
    if ([manager dob]) {
        
        pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]{2}-[0-9]{2}-[0-9]{4}"];
        
        if ([pred evaluateWithObject:[manager dob]]) {
            url = [url stringByAppendingFormat:@"%@%@",  @"&dob=", [manager dob]];
        }
    }
    
    // injecting sex into url
    if ([manager sex]) {
        pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[1-2]$"];
        
        if ([pred evaluateWithObject:[manager sex]]) {
            url = [url stringByAppendingFormat:@"%@%@", @"&sex=", [manager sex]];
        }
    }
    
    // inject custom vars into url
    NSMutableDictionary *customVars = [manager getCustomVars];
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
    return UIInterfaceOrientationMaskAll;
}

@end
