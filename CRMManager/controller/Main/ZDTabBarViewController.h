//
//  ZDTabBarViewController.h
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZDTabBarViewControllerDelegate;

@interface ZDTabBarViewController : UITabBarController

@property (weak, nonatomic) id <ZDTabBarViewControllerDelegate> customDelegate;

@end

@protocol ZDTabBarViewControllerDelegate <NSObject>

@optional
- (void)tabBarViewControllerDidLogOut:(ZDTabBarViewController *)controller;
- (void)tabBarViewControllerDidForgetGesturePasswordAndRelogin:(ZDTabBarViewController *)controller;

@end