//
//  ZDChanceCustomerDetailViewController.m
//  CRMManager
//
//  Created by peter on 14-8-18.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDChanceCustomerDetailViewController.h"
#import "ZDRecordAddOrEditViewController.h"
#import "ZDAddAndEditeViewController.h"

@interface ZDChanceCustomerDetailViewController ()<ZDRecordAddOrEditViewControllerDelegate,ZDAddAndEditeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * allRecords;
@property (strong, nonatomic) ZDContactRecord * selectedRecord;

@end

@implementation ZDChanceCustomerDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upadteContactRecords:) name:ZDUpdateContactRecordsNotification object:[ZDModeClient sharedModeClient]];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureView
{
    self.nameLabel.text = self.zdCustomer.customerName;
    self.mobileLabel.text = self.zdCustomer.mobile ? self.zdCustomer.mobile : @"未设置";
    self.allRecords = [[[ZDModeClient sharedModeClient] zdContactRecordsWithCustomerId:self.zdCustomer.customerId] mutableCopy];
}

#pragma mark - methods

- (void)upadteContactRecords:(NSNotification *)noti
{
    self.allRecords = [[[ZDModeClient sharedModeClient] zdContactRecordsWithCustomerId:self.zdCustomer.customerId] mutableCopy];
}

#pragma mark - properties

- (void)setAllRecords:(NSMutableArray *)allRecords
{
    _allRecords = allRecords;
    [self.tableView reloadData];
}

- (void)setHeadImageView:(UIImageView *)headImageView
{
    _headImageView = headImageView;
    _headImageView.image = [UIImage headImageForZDCustomer:self.zdCustomer andIsBig:YES];
}

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
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在删除,请稍后";
    ZDContactRecord * zdContactRecord = self.allRecords[indexPath.row];
    [self.allRecords removeObjectAtIndex:indexPath.row];
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (IBAction)swipeBack:(UISwipeGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)telephoneButtonPressed:(id)sender
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"拨号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"电话呼叫", nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)tapHeadImageView:(id)sender
{
    [self performSegueWithIdentifier:@"edit Display" sender:self];
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"recordAddOrEdit Display"]) {
        ZDRecordAddOrEditViewController * recordAddOrEditViewController = segue.destinationViewController;
        recordAddOrEditViewController.delegate = self;
        recordAddOrEditViewController.editedReocrd = self.selectedRecord;
        recordAddOrEditViewController.selectedCustomer = self.zdCustomer;
    } else if ([segue.identifier isEqualToString:@"edit Display"]) {
        ZDAddAndEditeViewController * addAndEditeViewController = segue.destinationViewController;
        addAndEditeViewController.delegate = self;
        addAndEditeViewController.editedCustomer = self.zdCustomer;
        addAndEditeViewController.mode = ZDAddAndEditeViewControllerModeEdit;
    }
}

#pragma mark - ZDRecordAddOrEditViewControllerDelegate

- (void)recordAddOrEditViewControllerDidFinishAddRecord:(ZDRecordAddOrEditViewController *)controller
{
    [self.navigationController popToViewController:self animated:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"添加记录成功";
    [hud hide:YES afterDelay:1];
}

- (void)recordAddOrEditViewControllerDidfinishEditRecord:(ZDRecordAddOrEditViewController *)controller
{
    [self.navigationController popToViewController:self animated:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"修改记录成功";
    [hud hide:YES afterDelay:1];
}

#pragma mkar - ZDAddAndEditController delegate

- (void)addAndEditeViewControllerDidFinishEdit:(ZDAddAndEditeViewController *)controller
{
    [self.navigationController popToViewController:self animated:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"编辑成功";
    [hud hide:YES afterDelay:1];
    self.zdCustomer = [[ZDModeClient sharedModeClient] zdCustomerWithCustomerId:self.zdCustomer.customerId];
    [self configureView];
}

#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"拨号"]) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            if (self.zdCustomer.mobile.length) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.zdCustomer.mobile]]];
            }
        }
    }
}

@end
