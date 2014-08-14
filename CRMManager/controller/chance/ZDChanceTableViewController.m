//
//  ZDChanceTableViewController.m
//  CRMManager
//
//  Created by 施赛峰 on 14-8-14.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDChanceTableViewController.h"

@interface ZDChanceTableViewController ()<SSFLeftRightSwipeTableViewCellDelegate>

@end

@implementation ZDChanceTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SSFLeftRightSwipeTableViewCell" bundle:nil] forCellReuseIdentifier:@"SSFLeftRightSwipeTableViewCell"];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSFLeftRightSwipeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SSFLeftRightSwipeTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.label.text = @"hahaha";
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SSFLeftRightSwipeTableViewCell * cell = (SSFLeftRightSwipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell.isEditMode) {
        //到下一界面
    }
}

//#pragma mark - UIGestureRecognizerDelegate
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([gestureRecognizer.view isKindOfClass:[UITableView class]]) {
//        return YES;
//    }
//    return NO;
//}

#pragma mark - SSFLeftRightSwipeTableViewCellDelegate

- (void)leftRightSwipeTableViewCellDeleteButtonPressed:(SSFLeftRightSwipeTableViewCell *)cell
{}

- (void)leftRightSwipeTableViewCellEditeButtonPressed:(SSFLeftRightSwipeTableViewCell *)cell
{}

@end
