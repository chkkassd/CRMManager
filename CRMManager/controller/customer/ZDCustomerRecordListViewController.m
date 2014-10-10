//
//  ZDCustomerRecordListViewController.m
//  CRMManager
//
//  Created by apple on 14-8-26.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDCustomerRecordListViewController.h"
#import "ZDModeClient.h"
#import "ZDRecordAddOrEditViewController.h"
#import "AllCustomerCategoryHeaders.h"

@interface ZDCustomerRecordListViewController () <ZDRecordAddOrEditViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray * allRecords;
@property (strong, nonatomic) ZDContactRecord * selectedRecord;

@end

@implementation ZDCustomerRecordListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRecords:) name:ZDUpdateContactRecordsNotification object:[ZDModeClient sharedModeClient]];
    [self configureView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - methods

- (void)configureView
{
    self.title = self.zdCustomer.customerName;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshContactRecords) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshContactRecords
{
    [[ZDModeClient sharedModeClient] refreshContactRecordsWithCustomerId:self.zdCustomer.customerId CompletionHandler:^(NSError *error) {
        [self.refreshControl endRefreshing];
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (!error) {
            hud.labelText = @"刷新成功";
            [hud hide:YES afterDelay:1];
            self.allRecords = [[[ZDModeClient sharedModeClient] zdContactRecordsWithCustomerId:self.zdCustomer.customerId] mutableCopy];
        } else {
            hud.labelText = @"刷新失败";
            [hud hide:YES afterDelay:1];
        }
    }];
}

- (void)updateRecords:(NSNotification *)noti
{
    self.allRecords = [[[ZDModeClient sharedModeClient] zdContactRecordsWithCustomerId:self.zdCustomer.customerId] mutableCopy];
}

- (NSString *)contentStringFromJsonString:(NSString *)jsonString
{
    if (!jsonString.length) return @"";
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"< br>" withString:@"\n"];
    return jsonString;
}

#pragma makr - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 无论修改还是新增，zdCustomer都需要穿过去
    ZDRecordAddOrEditViewController* recordAddOrEditViewController = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"Edit Contact"]) {
        recordAddOrEditViewController.editedReocrd = self.selectedRecord;
    }
    recordAddOrEditViewController.delegate = self;
    recordAddOrEditViewController.selectedCustomer = self.zdCustomer;
}

#pragma mark - properties

- (void)setZdCustomer:(ZDCustomer *)zdCustomer
{
    _zdCustomer = zdCustomer;
    self.allRecords = [[[ZDModeClient sharedModeClient] zdContactRecordsWithCustomerId:zdCustomer.customerId] mutableCopy];
}

- (void)setAllRecords:(NSMutableArray *)allRecords
{
    _allRecords = allRecords;
    [self.tableView reloadData];
}

#pragma mark - table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"record Cell" forIndexPath:indexPath];
    ZDContactRecord * zdContactRecord = self.allRecords[indexPath.row];
    cell.textLabel.text = [self contentStringFromJsonString:zdContactRecord.content];
    
    if (zdContactRecord.contactTime.length) {
        NSString * time1 = [zdContactRecord.contactTime substringToIndex:10];
        NSString * time2 = [zdContactRecord.contactTime substringWithRange:NSMakeRange(11, 5)];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@    %@",time1,time2];
    } else {
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在删除,请稍后";
    ZDContactRecord * zdContactRecord = self.allRecords[indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //调接口删除网上数据，并删除数据库数据
        [[ZDModeClient sharedModeClient] deleteContactRecordWithCustomerId:self.zdCustomer.customerId recordId:zdContactRecord.recordId completionHandler:^(NSError * error) {
            if (!error) {
                //删除成功
                hud.labelText = @"删除成功";
                [hud hide:YES afterDelay:1];
            } else {
                //删除失败
                hud.labelText = @"删除失败";
                [hud hide:YES afterDelay:1];
            }
        }];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRecord = self.allRecords[indexPath.row];
    [self performSegueWithIdentifier:@"Edit Contact" sender:self];
}

#pragma mark - ZDRecordAddOrEditViewControllerDelegate

- (void)recordAddOrEditViewControllerDidFinishAddRecord:(ZDRecordAddOrEditViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"增加成功";
    [hud hide:YES afterDelay:1];
}

- (void)recordAddOrEditViewControllerDidfinishEditRecord:(ZDRecordAddOrEditViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"修改成功";
    [hud hide:YES afterDelay:1];
}


@end
