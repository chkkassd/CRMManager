//
//  ZDAppDelegate.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDAppDelegate.h"

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
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:20.0],UITextAttributeFont,nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //设置statusbar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
