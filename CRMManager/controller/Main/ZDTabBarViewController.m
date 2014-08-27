//
//  ZDTabBarViewController.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
// 这个类是总的Main控制器类

#import "ZDTabBarViewController.h"
#import "ZDChanceViewController.h"
#import "ZDGesturePasswordViewController.h"
#import "AllCustomerCategoryHeaders.h"
#import "ZDSettingViewController.h"

#define DefaultEnterBackgroundTime  5.0

@interface ZDTabBarViewController ()<ZDGesturePasswordViewControllerDelegate,ZDSettingViewControllerDelegate>

@property (strong, nonatomic) NSDate * enterBackgroundDate;
@property (strong, nonatomic) NSDate * enterForegroundDate;
@property (strong, nonatomic) ZDManagerUser * zdManagerUser;
@property (strong, nonatomic) Reachability * reachability;
@property (strong, nonatomic) ZDChanceViewController * chanceViewController;
@property (strong, nonatomic) ZDSettingViewController * settingViewController;

@end

@implementation ZDTabBarViewController

- (void)awakeFromNib
{
    self.settingViewController = [[self.viewControllers[3] viewControllers] firstObject];
    self.settingViewController.delegate = self;
    
    self.chanceViewController = [[self.viewControllers[0] viewControllers] firstObject];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    
    for (int i = 0; i < self.tabBar.items.count; i++)
    {
        UITabBarItem * barItem = self.tabBar.items[i];
        barItem.selectedImage = [UIImage imageWithIndex:i];
    }
    [self startReachabilityNotification];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self cancelReachabilityNotification];
}

#pragma mark - properties

- (ZDManagerUser *)zdManagerUser
{
    if (!_zdManagerUser) {
        _zdManagerUser = [ZDModeClient sharedModeClient].zdManagerUser;
    }
    return _zdManagerUser;
}

- (Reachability *)reachability
{
    if (!_reachability) {
        _reachability = [Reachability reachabilityForInternetConnection];
    }
    return _reachability;
}

#pragma mark - methods

- (void)enterBackground
{
    self.enterBackgroundDate = [NSDate date];
}

- (void)enterForeground
{
    if (self.zdManagerUser.gesturePasswordSwitch) {
        //手势密码开启
        self.enterForegroundDate = [NSDate date];
        NSTimeInterval time = [self.enterForegroundDate timeIntervalSinceDate:self.enterBackgroundDate];
        if (time >= DefaultEnterBackgroundTime) {
            [self presentToGesturePasswordView];
        }
    }
    
}

- (void)presentToGesturePasswordView
{
    ZDGesturePasswordViewController * gesturePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ZDGesturePasswordViewController"];
    gesturePasswordViewController.delegate = self;
    [self presentViewController:gesturePasswordViewController animated:YES completion:NULL];
}

#pragma mark - ZDGesturePasswordViewDelegate

- (void)gesturePasswordViewControllerDidFinish:(ZDGesturePasswordViewController *)controller
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - ZDSettingview delegate

- (void)settingViewControllerDidLoginOut:(ZDSettingViewController *)controller
{
    [self.customDelegate tabBarViewControllerDidLogOut:self];
}

#pragma mark - reachability 网络实时监测

- (void)reachabilityChanged:(NSNotification *)noti
{
    Reachability* curReach = [noti object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    switch (status) {
        case NotReachable: {
            [self.chanceViewController checkNetAndShow:NO];
        } break;
        case ReachableViaWiFi: {
            [self.chanceViewController checkNetAndShow:YES];
        } break;
        case ReachableViaWWAN: {
            [self.chanceViewController checkNetAndShow:YES];
        } break;
        default: break;
    }
}

- (void)startReachabilityNotification
{
    //为防止出错，先关闭
    [self cancelReachabilityNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    [self.reachability performSelector:@selector(startNotifier)];
}

- (void)cancelReachabilityNotification {
    [self.reachability performSelector:@selector(stopNotifier)];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
