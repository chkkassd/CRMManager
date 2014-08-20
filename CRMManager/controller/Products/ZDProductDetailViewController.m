//
//  ZDProductDetailViewController.m
//  CrmApp
//
//  Created by apple on 14-7-30.
//  Copyright (c) 2014年 com.zendai. All rights reserved.
//

#import "ZDProductDetailViewController.h"

@interface ZDProductDetailViewController ()

@end

@implementation ZDProductDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
