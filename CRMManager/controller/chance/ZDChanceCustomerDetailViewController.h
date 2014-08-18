//
//  ZDChanceCustomerDetailViewController.h
//  CRMManager
//
//  Created by peter on 14-8-18.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDModeClient.h"

@interface ZDChanceCustomerDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) ZDCustomer * zdCustomer;

@end
