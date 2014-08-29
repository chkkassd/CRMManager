//
//  ZDAddAndEditeViewController.h
//  CRMManager
//
//  Created by peter on 14-8-19.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDModeClient.h"

typedef enum {
    ZDAddAndEditeViewControllerModeAdd,
    ZDAddAndEditeViewControllerModeEdit
}addAndEditeViewControllerMode;

@protocol ZDAddAndEditeViewControllerDelegate;

@interface ZDAddAndEditeViewController : UIViewController<UIActionSheetDelegate>

@property (nonatomic) addAndEditeViewControllerMode mode;
@property (strong, nonatomic) ZDCustomer * editedCustomer;
@property (strong, nonatomic) NSDictionary * infoDic;//用于通讯录添加
@property (weak, nonatomic) id <ZDAddAndEditeViewControllerDelegate> delegate;

@end

@protocol ZDAddAndEditeViewControllerDelegate <NSObject>

@optional
- (void)addAndEditeViewControllerDidFinishAdd:(ZDAddAndEditeViewController *)controller;
- (void)addAndEditeViewControllerDidFinishEdit:(ZDAddAndEditeViewController *)controller;

@end