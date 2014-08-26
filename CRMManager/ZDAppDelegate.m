//
//  ZDAppDelegate.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDAppDelegate.h"
#import "ZDModeClient.h"

@implementation ZDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self setCustomizeAppearance];
    
    return YES;
}

#pragma mark - Set all apprearences

- (void)setCustomizeAppearance
{
    //设置navigationBar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           UITextAttributeTextColor: [UIColor whiteColor],
                                                           UITextAttributeFont:[UIFont systemFontOfSize:20]
                                                           }];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //设置statusbar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSString* userInfo = [[NSUserDefaults standardUserDefaults] stringForKey:DefaultCurrentUserId];
    if (userInfo) {
        // 已经登录过，直接呈现手势密码
    }
}

@end
