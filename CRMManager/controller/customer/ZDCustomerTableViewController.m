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
#import "ZDScanBarCodeViewController.h"

#define SSFLeftRightSwipe_TableViewCell @"SSFLeftRightSwipeTableViewCell"

@interface ZDCustomerTableViewController () <SSFLeftRightSwipeTableViewCellDelegate,ZDScanBarCodeViewControllerDelegate>

@property (nonatomic, strong) NSArray * allCurrentCustomers;
@property (nonatomic, strong) NSArray * filterdCurrentCustomers;
@property (strong, nonatomic) ZDCustomer * selectedZDCustomer;

@end

@implementation ZDCustomerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentCustomers:) name:ZDUpdateCustomersNotification object:[ZDModeClient sharedModeClient]];
    
    [self.tableView registerNib:[UINib nibWithNibName:SSFLeftRightSwipe_TableViewCell bundle:nil] forCellReuseIdentifier:SSFLeftRightSwipe_TableViewCell];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:SSFLeftRightSwipe_TableViewCell bundle:nil] forCellReuseIdentifier:SSFLeftRightSwipe_TableViewCell];
    
    [self configureRefreshController];
    self.allCurrentCustomers = [ZDModeClient sharedModeClient].allZDCurrentCustomers;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - methods

- (void)updateCurrentCustomers:(NSNotification *)noti
{
    self.allCurrentCustomers = [ZDModeClient sharedModeClient].allZDCurrentCustomers;
}

- (void)configureRefreshController
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshCustomerView) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshCustomerView
{
    [[ZDModeClient sharedModeClient] refreshCustomersCompletionHandler:^(NSError *error) {
        [self.refreshControl endRefreshing];
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (!error) {
            self.allCurrentCustomers = [ZDModeClient sharedModeClient].allZDCurrentCustomers;
            hud.labelText = @"刷新成功";
        } else {
            hud.labelText = @"刷新失败";
        }
        [hud hide:YES afterDelay:1];
    }];
}

#pragma mark - action

- (IBAction)scanButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"show scanView" sender:self];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filterdCurrentCustomers.count;
    } else {
       return self.allCurrentCustomers.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSFLeftRightSwipeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SSFLeftRightSwipe_TableViewCell forIndexPath:indexPath];
    cell.delegate = self;
    cell.startGesture = NO;//关闭手势
    
    ZDCustomer * customer = [[ZDCustomer alloc] init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        customer = self.filterdCurrentCustomers[indexPath.row];
    } else {
        customer = self.allCurrentCustomers[indexPath.row];
    }
    
    if ([[ZDModeClient sharedModeClient] birthRemindWithCustomerId:customer.customerId].length) {
        cell.alertImageView.image = [UIImage imageNamed:@"ico_client_new1"];
    } else {
        cell.alertImageView.image = nil;
    }
    
    cell.label.text = customer.customerName;
    
    NSArray * businessLists = [[ZDModeClient sharedModeClient] zdBusinessListsWithCustomerId:customer.customerId];
    NSUInteger count = businessLists.count ? businessLists.count :0;
    cell.interestLabel.text = [NSString stringWithFormat:@"共%d笔业务",(int)count];
    cell.headImageView.image = [UIImage headImageForZDCustomer:customer andIsBig:NO];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
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

- (void)setAllCurrentCustomers:(NSArray *)allCurrentCustomers
{
    _allCurrentCustomers = allCurrentCustomers;
    [self.tableView reloadData];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show List"]) {
        ZDCustomerListViewController * listViewController = segue.destinationViewController;
        listViewController.customer = self.selectedZDCustomer;
    } else if ([segue.identifier isEqualToString:@"show scanView"]) {
        ZDScanBarCodeViewController * sbvc = segue.destinationViewController;
        sbvc.delegate = self;
    }
}

#pragma mark - search display controller delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"customerName contains[cd] %@",searchString];
    self.filterdCurrentCustomers = [self.allCurrentCustomers filteredArrayUsingPredicate:predicate];
    return YES;
}

#pragma mark - scan barcode view delegate

- (void)scanBarCodeViewControllerDidConfirmLoginOnWeb:(ZDScanBarCodeViewController *)controller
{
    [self.navigationController popToViewController:self animated:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"登陆CRM Web系统成功";
    [hud hide:YES afterDelay:2];
}

- (void)scanBarCodeViewControllerDidCancleLoginOnWeb:(ZDScanBarCodeViewController *)controller
{
    [self.navigationController popToViewController:self animated:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"取消登陆CRM Web系统";
    [hud hide:YES afterDelay:2];
}

@end
