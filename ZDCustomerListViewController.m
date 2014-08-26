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
    
    [self configureView];
}

#pragma mark - methods

- (void)configureView
{
    if (self.customer) {
        self.headImageView.image = [UIImage headImageForZDCustomer:self.customer andIsBig:YES];
        self.nameLabel.text = self.customer.customerName;
        self.mobileLabel.text = self.customer.mobile;
    }
    
    self.listItem = @[@{@"image": @"ico_currentClient_detail",
                        @"labelName": @"详细信息"},
                      @{@"image": @"ico_currentClient_invest",
                        @"labelName": @"理财记录"},
                      @{@"image": @"ico_currentClient_contact",
                        @"labelName": @"联系记录"}];
}

#pragma mark - Action

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)phoneButtonPressed:(id)sender
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"拨号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"电话呼叫", nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
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
    
    return cell;
}

#pragma mark - table view delegate

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

#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (self.customer.mobile.length) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.customer.mobile]]];
        }

    }
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show business"]) {
        ZDCustomerBusinessTableViewController * zdCustomerBusinessTableViewController = segue.destinationViewController;
        zdCustomerBusinessTableViewController.customer = self.customer;
    }
}

@end
