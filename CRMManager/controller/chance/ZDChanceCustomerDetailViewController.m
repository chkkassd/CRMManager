//
//  ZDChanceCustomerDetailViewController.m
//  CRMManager
//
//  Created by peter on 14-8-18.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDChanceCustomerDetailViewController.h"
#import "ZDRecordAddOrEditViewController.h"

@interface ZDChanceCustomerDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * allRecords;
@property (strong, nonatomic) ZDContactRecord * selectedRecord;

@end

@implementation ZDChanceCustomerDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
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

- (void)configureView
{
    self.nameLabel.text = self.zdCustomer.customerName;
    self.mobileLabel.text = self.zdCustomer.mobile ? self.zdCustomer.mobile : @"未设置";
    self.allRecords = [[ZDModeClient sharedModeClient] zdContactRecordsWithCustomerId:self.zdCustomer.customerId];
}

#pragma mark - properties


#pragma mark - table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"customerDetail Cell" forIndexPath:indexPath];
    ZDContactRecord * zdContactRecord = self.allRecords[indexPath.row];
    cell.textLabel.text = zdContactRecord.content;
    cell.detailTextLabel.text = zdContactRecord.contactTime;
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //调接口删除网上数据，并删除数据库数据
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRecord = self.allRecords[indexPath.row];
    [self performSegueWithIdentifier:@"recordAddOrEdit Display" sender:self];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addButtonPressed:(id)sender
{
    self.selectedRecord = nil;
    [self performSegueWithIdentifier:@"recordAddOrEdit Display" sender:self];
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"recordAddOrEdit Display"]) {
        ZDRecordAddOrEditViewController * recordAddOrEditViewController = segue.destinationViewController;
        recordAddOrEditViewController.editedReocrd = self.selectedRecord;
    }
}

@end
