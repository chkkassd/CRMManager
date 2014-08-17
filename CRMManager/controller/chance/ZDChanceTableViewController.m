//
//  ZDChanceTableViewController.m
//  CRMManager
//
//  Created by 施赛峰 on 14-8-14.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDChanceTableViewController.h"
#import "SSFSegmentControl.h"

@interface ZDChanceTableViewController ()<SSFLeftRightSwipeTableViewCellDelegate,SSFSegmentControlDelegate>

@property (strong, nonatomic) SSFSegmentControl * segmentedControl;

@end

@implementation ZDChanceTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SSFLeftRightSwipeTableViewCell" bundle:nil] forCellReuseIdentifier:@"SSFLeftRightSwipeTableViewCell"];
}

#pragma mark - properties

- (SSFSegmentControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [SSFSegmentControl SSFSegmentedControlInstance];
        _segmentedControl.delegate = self;
    }
    return _segmentedControl;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.segmentedControl;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.segmentedControl.frame.size.height;
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

#pragma mark - SSFSegmentControlDelegate

- (void)SSFSegmentControlDidPressed:(UIView *)view selectedIndex:(NSInteger)selectedIndex
{
    switch (selectedIndex) {
        case 0:
            NSLog(@"it is %ld",(long)selectedIndex);
            break;
        case 1:
            NSLog(@"it is %ld",(long)selectedIndex);
            break;
        case 2:
            NSLog(@"it is %ld",(long)selectedIndex);
            break;
        case 3:
            NSLog(@"it is %ld",(long)selectedIndex);
            break;
            
        default:
            break;
    }
}

@end
