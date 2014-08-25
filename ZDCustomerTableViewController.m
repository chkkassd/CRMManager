//
//  ZDCustomerTableViewController.m
//  CRMManager
//
//  Created by peter on 14-8-21.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDCustomerTableViewController.h"

@interface ZDCustomerTableViewController ()

@end

@implementation ZDCustomerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    ZDCustomer * zdCustomer = [[ZDModeClient sharedModeClient].allZDCustomers firstObject];
    NSArray * arr = [[ZDModeClient sharedModeClient] zdBusinessListsWithCustomerId:zdCustomer.customerId];
}

@end
