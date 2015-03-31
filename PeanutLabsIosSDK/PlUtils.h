//
//  PlUtils.h
//
//  Created by Peanut Labs Inc on 1/10/15.
//  Copyright (c) 2015 PeanutLabs. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifdef DEBUG

#define PL_Log( s, ... ) NSLog( @"<%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define PL_LogFunction PL_Log(@"%s called", __FUNCTION__)

#else

#define PL_Log( s, ... )
#define PL_LogFunction

#endif

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define IS_PHONE_DEVICE() UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

@interface PlUtils : NSObject

@end
