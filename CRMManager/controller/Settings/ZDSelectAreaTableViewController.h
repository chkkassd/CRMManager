//
//  ZDSelectAreaTableViewController.h
//  CRMManager
//
//  Created by peter on 14-9-17.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDModeClient.h"
#import "AllCustomerCategoryHeaders.h"

@protocol ZDSelectAreaTableViewControllerDelegate;
@interface ZDSelectAreaTableViewController : UITableViewController

@property (weak, nonatomic) id <ZDSelectAreaTableViewControllerDelegate> delegate;

@end

@protocol ZDSelectAreaTableViewControllerDelegate <NSObject>

- (void)selectAreaTableViewControllerDidFinishSelectArea:(ZDSelectAreaTableViewController *)controller;

@end