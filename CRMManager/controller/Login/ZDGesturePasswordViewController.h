//
//  ZDGesturePasswordViewController.h
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDModeClient.h"
#import "AllCustomerCategoryHeaders.h"

@protocol ZDGesturePasswordViewControllerDelegate;

@interface ZDGesturePasswordViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) id <ZDGesturePasswordViewControllerDelegate> delegate;

@end

@protocol ZDGesturePasswordViewControllerDelegate <NSObject>

@optional
- (void)gesturePasswordViewControllerDidFinish:(ZDGesturePasswordViewController *)controller;
- (void)gesturePasswordViewControllerDidForgetGesturePassword:(ZDGesturePasswordViewController *)controller;

@end