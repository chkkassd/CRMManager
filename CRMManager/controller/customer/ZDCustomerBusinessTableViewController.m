//
//  ZDCustomerBusinessTableViewController.m
//  CRMManager
//
//  Created by peter on 14-8-26.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDCustomerBusinessTableViewController.h"
#import "ZDCustomerBusinessTableViewCellNormal.h"
#import "ZDCustomerBusinessTableViewCellUnfold.h"

@interface ZDCustomerBusinessTableViewController ()

@property (strong, nonatomic) NSArray * businessLists;
@property (strong, nonatomic) NSMutableArray * dataBusinessLists;

@end

@implementation ZDCustomerBusinessTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBusinessLists:) name:ZDUpdateBusinessAndBusinessListsNotification object:[ZDModeClient sharedModeClient]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - methods

- (void)updateBusinessLists:(NSNotification *)noti
{
    self.businessLists = [[ZDModeClient sharedModeClient] zdBusinessListsWithCustomerId:_customer.customerId];
}

- (UIColor *)backgroundColorForNormalCellWithIndex:(NSInteger)index
{
    NSArray * colors = @[[UIColor colorWithRed:42/255.0 green:135/255.0 blue:194/255.0 alpha:1.0],
                         [UIColor colorWithRed:68/255.0 green:182/255.0 blue:229/255.0 alpha:1.0],
                         [UIColor colorWithRed:57/255.0 green:203/255.0 blue:208/255.0 alpha:1.0],
                         [UIColor colorWithRed:60/255.0 green:230/255.0 blue:186/255.0 alpha:1.0]];
    NSInteger a = (index + 1) % 4;
    switch (a) {
        case 1:
            return colors[0];
            break;
        case 2:
            return colors[1];
            break;
        case 3:
            return colors[2];
            break;
        case 0:
            return colors[3];
            break;
        default:
            break;
    }
    return colors[0];//默认色
}

#pragma mark - properties

- (void)setCustomer:(ZDCustomer *)customer
{
    _customer = customer;
    self.businessLists = [[ZDModeClient sharedModeClient] zdBusinessListsWithCustomerId:_customer.customerId];
}

- (void)setBusinessLists:(NSArray *)businessLists
{
    _businessLists = businessLists;
    
    self.dataBusinessLists = [[NSMutableArray alloc] init];
    for (ZDBusinessList * obj in _businessLists) {
        NSDictionary * dic = @{@"cell": @"normal",
                               @"object": obj};
        [self.dataBusinessLists addObject:dic];
    }
}

- (void)setDataBusinessLists:(NSMutableArray *)dataBusinessLists
{
    _dataBusinessLists = [dataBusinessLists mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataBusinessLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.dataBusinessLists[indexPath.row] objectForKey:@"cell"] isEqualToString:@"normal"]) {
        return 133.0;
    } else {
        return 167.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZDBusinessList * zdBusinessList = [self.dataBusinessLists[indexPath.row] objectForKey:@"object"];
    
    if ([[self.dataBusinessLists[indexPath.row] objectForKey:@"cell"] isEqualToString:@"normal"]) {
        ZDCustomerBusinessTableViewCellNormal * cell = [tableView dequeueReusableCellWithIdentifier:@"businessNomalCell" forIndexPath:indexPath];
        cell.productNameLabel.text = zdBusinessList.pattern;
        cell.numberLabel.text = zdBusinessList.feLendNo;
        cell.backGroundView.backgroundColor = [self backgroundColorForNormalCellWithIndex:indexPath.row];
        return cell;
    } else {
        ZDCustomerBusinessTableViewCellUnfold * cell = [tableView dequeueReusableCellWithIdentifier:@"businessUnfoldCell" forIndexPath:indexPath];
        cell.moneyLabel.text = zdBusinessList.investAmt;
//        cell.stateLabel.text = zdBusinessList.status;
        cell.dateLabel.text = zdBusinessList.endDate;
        return cell;
    }
}

#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZDBusinessList * zdBusinessList = [self.dataBusinessLists[indexPath.row] objectForKey:@"object"];
    NSIndexPath * index = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
    
    if ([[self.dataBusinessLists[indexPath.row] objectForKey:@"cell"] isEqualToString:@"normal"]) {
        ZDCustomerBusinessTableViewCellNormal * normalCell = (ZDCustomerBusinessTableViewCellNormal *)[tableView cellForRowAtIndexPath:indexPath];
        if (normalCell.isUnFold) {
            //已展开
            [self.dataBusinessLists removeObjectAtIndex:index.row];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationMiddle];
            [tableView endUpdates];
        } else {
            //未展开
            NSDictionary * dic = @{@"cell": @"unfold",
                                   @"object": zdBusinessList};
            [self.dataBusinessLists insertObject:dic atIndex:index.row];
            [tableView beginUpdates];
            [tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationMiddle];
            [tableView endUpdates];
        }
    }
}

@end
