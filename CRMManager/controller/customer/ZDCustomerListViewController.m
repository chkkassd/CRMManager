//
//  ZDCustomerDetailViewController.m
//  CRMManager
//
//  Created by peter on 14-8-26.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDCustomerListViewController.h"
#import "ZDCustomerListTableViewCell.h"
#import "ZDCustomerBusinessTableViewController.h"
#import "ZDCustomerRecordListViewController.h"
#import "ZDCustomerDetailViewController.h"

@interface ZDCustomerListViewController ()

@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (weak, nonatomic) IBOutlet UIImageView * headImageView;
@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) IBOutlet UILabel * mobileLabel;
@property (nonatomic, strong) NSArray * listItem;

@end

@implementation ZDCustomerListViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBrithReminds:) name:ZDUpdateBirthRemindsNotification object:[ZDModeClient sharedModeClient]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInvestmentReminds:) name:ZDUpdateInvestmentRemindsNotification object:[ZDModeClient sharedModeClient]];
    
    [self configureView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - methods

- (void)updateBrithReminds:(NSNotification *)noti
{
    [self.tableView reloadData];
}

- (void)updateInvestmentReminds:(NSNotification *)noti
{
    [self.tableView reloadData];
}

- (void)configureView
{
    self.headImageView.image = [UIImage headImageForZDCustomer:self.customer andIsBig:YES];
    self.nameLabel.text = self.customer.customerName ? self.customer.customerName : @"未设置";
    self.mobileLabel.text = [self stringForHiddenMobile:self.customer.mobile];
    self.listItem = @[@{@"image": @"ico_currentClient_detail",
                        @"labelName": @"详细信息"},
                      @{@"image": @"ico_currentClient_invest",
                        @"labelName": @"理财记录"},
                      @{@"image": @"ico_currentClient_contact",
                        @"labelName": @"联系记录"}];
}

- (NSString *)stringForHiddenMobile:(NSString *)mobilestring
{
    if (!mobilestring.length) {
        return @"未设置";
    } else if (mobilestring.length < 8) return mobilestring;
    
    return [mobilestring stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
}

#pragma mark - Action

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)phoneButtonPressed:(id)sender
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"拨号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"电话呼叫", nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)swipeToBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (self.customer.mobile.length) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.customer.mobile]]];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZDCustomerListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"customer list cell" forIndexPath:indexPath];
    
    cell.label.text = self.listItem[indexPath.row][@"labelName"];
    cell.imageViewFirst.image = [UIImage imageNamed:self.listItem[indexPath.row][@"image"]];
    
    NSString * birthString = [[ZDModeClient sharedModeClient] birthRemindWithCustomerId:self.customer.customerId];
    if (birthString.length && indexPath.row == 0) {
        cell.birthView.hidden = NO;
        cell.birthLabel.text = [birthString substringFromIndex:5];
    }
    if ([[ZDModeClient sharedModeClient] investmentRemindWithCustomerId:self.customer.customerId].count && indexPath.row == 1) {
        cell.investmentImageView.hidden = NO;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"Show Detail" sender:self];
    } else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"Show Record" sender:self];
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"show business" sender:self];
    }
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show business"]) {
        ZDCustomerBusinessTableViewController * customerBusinessTableViewController = segue.destinationViewController;
        customerBusinessTableViewController.customer = self.customer;
    } else if ([segue.identifier isEqualToString:@"Show Record"]) {
        ZDCustomerRecordListViewController * recordViewController = segue.destinationViewController;
        recordViewController.zdCustomer = self.customer;
    } else if ([segue.identifier isEqualToString:@"Show Detail"]) {
        ZDCustomerDetailViewController * detailViewController = segue.destinationViewController;
        detailViewController.zdCustomer = self.customer;
    }
}

@end
