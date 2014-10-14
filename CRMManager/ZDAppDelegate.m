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
    [self setCustomizeAppearance];
    
    [self selectRootViewControllerByNewFeature];
    
    [self setLocalNotification];
    
    UILocalNotification * localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //注册用户设置成功
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSString * string = notification.userInfo[@"key"];
    if ([string isEqualToString:@"remindAndBusiness"]) {
        //5.获取并保存所有客户的business
        [[ZDModeClient sharedModeClient] fetchAndSaveAllBusinessListsWithManagerId:[ZDModeClient sharedModeClient].zdManagerUser.userid];
        //6.获取生日提醒信息
        [[ZDModeClient sharedModeClient] fetchAndSaveBirthRemindInfoWithManagerId:[ZDModeClient sharedModeClient].zdManagerUser.userid pageSize:@"20" pageNo:@"1"];
        //7.获取投资提醒信息
        [[ZDModeClient sharedModeClient] fetchAndSaveInvestmentRemindInfoWithManagerId:[ZDModeClient sharedModeClient].zdManagerUser.userid pageSize:@"50" pageNo:@"1"];
        
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
}

- (void)selectRootViewControllerByNewFeature
{
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    NSString * key = (NSString *)kCFBundleVersionKey;
    
    // 1.从Info.plist中取出版本号
    NSString * version = [NSBundle mainBundle].infoDictionary[key];
    
    // 2.从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if ([version isEqualToString:saveVersion]) { // 不是第一次使用这个版本
        // 显示状态栏
        [UIApplication sharedApplication].statusBarHidden = NO;
        UIViewController * main = [sb instantiateViewControllerWithIdentifier:@"login"];
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

#pragma mark - localNotification

- (void)setLocalNotification
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version < 8.0) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    } else {
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
        
    UILocalNotification * localNotification = [[UILocalNotification alloc] init];
    
    //set the fire date
    NSDate * now = [NSDate date];
    NSCalendar * calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents * dateComponents = [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:now];
    NSDateComponents * fireDateComponts = [[NSDateComponents alloc] init];
    [fireDateComponts setYear:[dateComponents year]];
    [fireDateComponts setMonth:[dateComponents month]];
    [fireDateComponts setDay:[dateComponents day]];
    [fireDateComponts setHour:1];
    [fireDateComponts setMinute:11];
    [fireDateComponts setSecond:11];
    NSDate * fireDate = [calendar dateFromComponents:fireDateComponts];
    
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSCalendarUnitDay;
    localNotification.alertBody = @"投资,生日,理财记录更新";
    localNotification.alertAction = @"打开";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.userInfo = @{@"key" : @"remindAndBusiness"};
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
