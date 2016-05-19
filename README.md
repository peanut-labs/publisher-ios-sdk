
# Peanut Labs Reward Center - Publisher iOS SDK

Peanut Labs connects your users with thousands of paid online surveys from big brands and market researchers. This SDK allows you to integrate our Reward Center within your iOS application. 

#The Reward Center

The Reward Center lists surveys and offers best suited for each of your members. It is highly customizable and positively engaging.

You get paid whenever your members complete a listing, and get to reward them back in the virtual currency of your choice.

All of this and much more is configured  and monitored through our Publisher Dashboard. To learn more and get access to our full set of tools, get in touch with us at publisher.integration@peanutlabs.com

#Integration

Check out <a href="http://peanut-labs.github.io/publisher-doc/" target="_blank">our integration guide</a> for step by step instructions on getting up and running with our Reward Center within your iOS application.

#Changelog
v0.5
- Updated iOS SDK bar behavior
  1. Hide sdk bar for profiler modal
  2. Hide sdk bar for pre-screener modal
  3. Hide sdk bar for survey landing page
  4. 'Back' button for main reward center page sdk bar update

v0.4
- Changed "Done" button to "Home" button and replaced into right side
- Replaced "X" button to "Exit" and moved it to the right side
- After done with survey "Done" button led back to the application, changed it into lead back to rewards center
- Supports custom url parameters
- Supports date of birth url parameter
- Supports gender url parameter
- Automatically sets locale for rewards center depends on device locale

v0.3
- Activity Indicator does not cover the toolbar anymore
- Fixing the frequent connectivity error issue

v0.2
- Always generate new user Id if the user switches account
- Support for all orientations on the iPhone

*	Open Rewards Center.

``` Objective-c
Open Rewards Center with User Id
[plManager setAppId:1111];
[plManager setAppKey:@"APP_KEY_HERE"];
[plManager setEndUserId:@"END_USER_ID_HERE"];

```

* Add dob and gender as a parameter

``` Objective-c
Setting gender // 1(male) or 2(female)
[plManager setSex: @"1"];

Setting Dob // MM-DD-YYYY
[plManager setDob: @"11-09-1999"];

```

``` Objective-c
First parameter should be var_key and second parameter should be var_val

[plManager addCustomParameter:@"firstName" value:@"Bilguun"];
[plManager addCustomParameter:@"lastName" value:@"Oyunchimeg"];

```
