//
//  ZDChanceViewController.m
//  CRMManager
//
//  Created by peter on 14-8-18.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDChanceViewController.h"

@interface ZDChanceViewController ()<SSFLeftRightSwipeTableViewCellDelegate,SSFSegmentControlDelegate>

@property (strong, nonatomic) SSFSegmentControl * segmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar * searchBar;
@property (weak, nonatomic) IBOutlet UIView* segmentView;
@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (strong, nonatomic) NSArray * allChanceCustomers;

@end

@implementation ZDChanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SSFLeftRightSwipeTableViewCell" bundle:nil] forCellReuseIdentifier:@"SSFLeftRightSwipeTableViewCell"];
    
    [self.segmentView addSubview:self.segmentedControl];
    
    //notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChanceCustomers:) name:ZDUpdateCustomersNotification object:[ZDModeClient sharedModeClient]];
    self.tableView.delaysContentTouches = NO;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - methods

- (void)updateChanceCustomers:(NSNotification *)noti
{
    self.allChanceCustomers = [ZDModeClient sharedModeClient].allZDChanceCustomers;
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

- (void)setAllChanceCustomers:(NSArray *)allChanceCustomers
{
    _allChanceCustomers = allChanceCustomers;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allChanceCustomers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSFLeftRightSwipeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SSFLeftRightSwipeTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.label.text = [self.allChanceCustomers[indexPath.row] customerName];
    cell.interestLabel.text = @"一般";//[self.allChanceCustomers[indexPath.row] cdHope];
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.segmentedControl;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return self.segmentedControl.frame.size.height;
//}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SSFLeftRightSwipeTableViewCell * cell = (SSFLeftRightSwipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell.isEditMode) {
        //到下一界面
    }
}

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
