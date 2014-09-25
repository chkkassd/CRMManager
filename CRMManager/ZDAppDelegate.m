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
    
    [self selectRootViewControllerByNewFeature];
    
    return YES;
}

- (void)selectRootViewControllerByNewFeature
{
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    NSString *key = (NSString *)kCFBundleVersionKey;
    
    // 1.从Info.plist中取出版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    
    // 2.从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if ([version isEqualToString:saveVersion]) { // 不是第一次使用这个版本
        // 显示状态栏
        [UIApplication sharedApplication].statusBarHidden = NO;
        UIViewController* main = [sb instantiateViewControllerWithIdentifier:@"login"];
        self.window.rootViewController = main;
        
        
    } else { // 版本号不一样：第一次使用新版本
        // 将新版本号写入沙盒
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 显示版本新特性界面
        self.window.rootViewController = [sb instantiateViewControllerWithIdentifier:@"newFeature"];
    }
    
    [self.window makeKeyAndVisible];

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

@end
