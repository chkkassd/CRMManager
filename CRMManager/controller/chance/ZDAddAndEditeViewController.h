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

@interface ZDAddAndEditeViewController : UIViewController<UIActionSheetDelegate>

@property (nonatomic) addAndEditeViewControllerMode mode;
@property (strong, nonatomic) ZDCustomer * editedCustomer;

@end
