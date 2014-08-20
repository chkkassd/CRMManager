//
//  ZDRecordAddOrEditViewController.h
//  CRMManager
//
//  Created by peter on 14-8-19.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDModeClient.h"
#import "AllCustomerCategoryHeaders.h"

@protocol ZDRecordAddOrEditViewControllerDelegate;

@interface ZDRecordAddOrEditViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) ZDContactRecord * editedReocrd;
@property (strong, nonatomic) ZDCustomer * selectedCustomer;
@property (weak, nonatomic) id <ZDRecordAddOrEditViewControllerDelegate> delegate;

@end

@protocol ZDRecordAddOrEditViewControllerDelegate <NSObject>

- (void)recordAddOrEditViewControllerDidFinishAddRecord:(ZDRecordAddOrEditViewController *)controller;
- (void)recordAddOrEditViewControllerDidfinishEditRecord:(ZDRecordAddOrEditViewController *)controller;

@end