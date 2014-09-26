//
//  ZDGesturePasswordSettingViewController.h
//  CRMManager
//
//  Created by peter on 14-8-12.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDSettingViewController.h"
#import "AllCustomerCategoryHeaders.h"
#import "ZDModeClient.h"

@protocol ZDGesturePasswordSettingViewControllerDelegate;
@interface ZDGesturePasswordSettingViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) id <ZDGesturePasswordSettingViewControllerDelegate> delegate;

@end

@protocol ZDGesturePasswordSettingViewControllerDelegate <NSObject>

- (void)gesturePasswordSettingViewControllerDidFinishPassword:(ZDGesturePasswordSettingViewController *)controller;

@end