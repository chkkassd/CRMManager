//
//  ZDChanceCustomerDetailViewController.h
//  CRMManager
//
//  Created by peter on 14-8-18.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDModeClient.h"
#import "AllCustomerCategoryHeaders.h"

@interface ZDChanceCustomerDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) ZDCustomer * zdCustomer;

@end
