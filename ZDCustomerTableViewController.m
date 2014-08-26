//
//  ZDCustomerTableViewController.m
//  CRMManager
//
//  Created by peter on 14-8-21.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDCustomerTableViewController.h"
#import "AllCustomerCategoryHeaders.h"
#import "ZDCustomerListViewController.h"

#define SSFLeftRightSwipe_TableViewCell @"SSFLeftRightSwipeTableViewCell"

@interface ZDCustomerTableViewController () <SSFLeftRightSwipeTableViewCellDelegate>

@property (nonatomic, strong) NSArray * allCurrentCustomers;
@property (strong, nonatomic) ZDCustomer * selectedZDCustomer;

@end

@implementation ZDCustomerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:SSFLeftRightSwipe_TableViewCell bundle:nil] forCellReuseIdentifier:SSFLeftRightSwipe_TableViewCell];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allCurrentCustomers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSFLeftRightSwipeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:SSFLeftRightSwipe_TableViewCell forIndexPath:indexPath];
    cell.delegate = self;
    
    ZDCustomer * customer = self.allCurrentCustomers[indexPath.row];
    cell.label.text = customer.customerName;
    
    NSString * interest = @"未分类";
    if ([customer.cdHope isEqual: @"1"]) {
        interest = @"强烈";
    } else if ([customer.cdHope isEqual: @"2"]) {
        interest = @"感兴趣";
    } else if ([customer.cdHope isEqual: @"3"]) {
        interest = @"一般";
    }
    cell.interestLabel.text = interest;
    cell.headImageView.image = [UIImage headImageForZDCustomer:customer andIsBig:NO];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedZDCustomer = self.allCurrentCustomers[indexPath.row];
    [self performSegueWithIdentifier:@"Show List" sender:self];
}

#pragma mark - SSFLeftRightSwipeTableViewCellDelegate

- (void)leftRightSwipeTableViewCellDeleteButtonPressed:(SSFLeftRightSwipeTableViewCell *)cell
{
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    ZDCustomer * zdCustomer = self.allCurrentCustomers[index.row];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在删除,请稍后";
    [[ZDModeClient sharedModeClient] deleteChanceCustomerWithCustomerId:zdCustomer.customerId completionHandler:^(NSError *error) {
        if (!error) {
            hud.labelText = @"删除成功";
            [hud hide:YES afterDelay:1];
        } else {
            hud.labelText = @"删除失败";
            [hud hide:YES afterDelay:1];
        }
    }];
}

- (void)leftRightSwipeTableViewCellEditeButtonPressed:(SSFLeftRightSwipeTableViewCell *)cell
{
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    self.selectedZDCustomer = self.allCurrentCustomers[index.row];
//    [self performSegueWithIdentifier:@"addAndEdit Display" sender:self];
}

- (void)leftRightSwipeTableViewCellTelephoneButtonPressed:(SSFLeftRightSwipeTableViewCell *)cell
{
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    self.selectedZDCustomer = self.allCurrentCustomers[index.row];
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"拨号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"电话呼叫", nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"拨号"]) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            if (self.selectedZDCustomer.mobile.length) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.selectedZDCustomer.mobile]]];
            }
        }
    }
}

#pragma mark - Properties
- (NSArray *)allCurrentCustomers
{
    if (!_allCurrentCustomers) {
        _allCurrentCustomers = [ZDModeClient sharedModeClient].allZDCurrentCustomers;
    }
    return _allCurrentCustomers;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show List"]) {
        ZDCustomerListViewController * listViewController = segue.destinationViewController;
        listViewController.customer = self.selectedZDCustomer;
    }
}

@end
