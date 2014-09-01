//
//  ZDSettingViewController.h
//  CrmApp
//
//  Created by apple on 14-7-22.
//  Copyright (c) 2014年 com.zendai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDModeClient.h"
#import "AllCustomerCategoryHeaders.h"

@protocol ZDSettingViewControllerDelegate;
@interface ZDSettingViewController : UITableViewController <UIActionSheetDelegate>

@property (weak, nonatomic) id <ZDSettingViewControllerDelegate> delegate;

@end

@protocol ZDSettingViewControllerDelegate <NSObject>

- (void)settingViewControllerDidLoginOut:(ZDSettingViewController *)controller;

@end