//
//  ZDProductDetailViewController.m
//  CrmApp
//
//  Created by apple on 14-7-30.
//  Copyright (c) 2014年 com.zendai. All rights reserved.
//

#import "ZDProductDetailViewController.h"

@interface ZDProductDetailViewController ()
- (IBAction)swipeToReturn:(id)sender;

@end

@implementation ZDProductDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(back:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipe];
}

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

- (IBAction)swipeToReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
