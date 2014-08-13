//
//  ZDTabBarViewController.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
// 这个类是总的Main控制器类

#import "ZDTabBarViewController.h"
#import "ZDGesturePasswordViewController.h"

#define DefaultEnterBackgroundTime  3.0

@interface ZDTabBarViewController ()<ZDGesturePasswordViewControllerDelegate>

@property (strong, nonatomic) NSDate * enterBackgroundDate;
@property (strong, nonatomic) NSDate * enterForegroundDate;
@property (strong, nonatomic) ZDManagerUser * zdManagerUser;

@end

@implementation ZDTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    for (int i = 0; i < self.tabBar.items.count; i++)
    {
        switch (i) {
            case 0:{
                UITabBarItem * barItem = self.tabBar.items[i];
                barItem.selectedImage = [UIImage imageNamed:@"main_ico_footer_chance_pressed"];
                 break;
            }
            case 1:{
                UITabBarItem * barItem = self.tabBar.items[i];
                barItem.selectedImage = [UIImage imageNamed:@"main_ico_footer_client_pressed"];
                break;
            }
            case 2:{
                UITabBarItem * barItem = self.tabBar.items[i];
                barItem.selectedImage = [UIImage imageNamed:@"main_ico_footer_product_pressed"];
                break;
            }
            case 3:{
                UITabBarItem * barItem = self.tabBar.items[i];
                barItem.selectedImage = [UIImage imageNamed:@"maini_ico_footer_setting_pressed"];
                break;
            }
            default:
                break;
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - properties

- (ZDManagerUser *)zdManagerUser
{
    if (!_zdManagerUser) {
        _zdManagerUser = [ZDModeClient sharedModeClient].zdManagerUser;
    }
    return _zdManagerUser;
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

@end
