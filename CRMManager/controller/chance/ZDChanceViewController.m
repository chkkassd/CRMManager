//
//  ZDChanceViewController.m
//  CRMManager
//
//  Created by peter on 14-8-18.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDChanceViewController.h"
#import "ZDChanceCustomerDetailViewController.h"
#import "ZDAddAndEditeViewController.h"

@interface ZDChanceViewController ()<SSFLeftRightSwipeTableViewCellDelegate,SSFSegmentControlDelegate,ZDAddAndEditeViewControllerDelegate>

@property (strong, nonatomic) SSFSegmentControl * segmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar * searchBar;
@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (strong, nonatomic) NSArray * allChanceCustomers;
@property (strong, nonatomic) NSArray * filteredChanceCustomers;
@property (strong, nonatomic) ZDCustomer * selectedZDCustomer;

@end

@implementation ZDChanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SSFLeftRightSwipeTableViewCell" bundle:nil] forCellReuseIdentifier:@"SSFLeftRightSwipeTableViewCell"];
    
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"SSFLeftRightSwipeTableViewCell" bundle:nil] forCellReuseIdentifier:@"SSFLeftRightSwipeTableViewCell"];
    
    //notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChanceCustomers:) name:ZDUpdateCustomersNotification object:[ZDModeClient sharedModeClient]];
    
    self.allChanceCustomers = [ZDModeClient sharedModeClient].allZDChanceCustomers;
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

#pragma mark - Action

- (IBAction)addButtonPressed:(id)sender
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"新增客户" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加",@"从通讯录导入", nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"添加"]) {
        self.selectedZDCustomer = nil;
        [self performSegueWithIdentifier:@"addAndEdit Display" sender:self];
    } else if ([buttonTitle isEqualToString:@"从通讯录导入"]) {
        //做通讯录导入操作
    }
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
//    switch (self.segmentedControl.selectedIndex) {
//        case 0:
//            
//            break;
//            
//        default:
//            break;
//    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filteredChanceCustomers.count;
    } else {
       return self.allChanceCustomers.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSFLeftRightSwipeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SSFLeftRightSwipeTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        ZDCustomer * zdFilterCustomer = self.filteredChanceCustomers[indexPath.row];
        cell.label.text = [zdFilterCustomer customerName];
        cell.headImageView.image = [UIImage headImageForZDCustomer:zdFilterCustomer andIsBig:NO];
    } else {
        ZDCustomer * zdCustomer = self.allChanceCustomers[indexPath.row];
       cell.label.text = [zdCustomer customerName];
        cell.headImageView.image = [UIImage headImageForZDCustomer:zdCustomer andIsBig:NO];
    }
    
    cell.interestLabel.text = @"一般";//[self.allChanceCustomers[indexPath.row] cdHope];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        return self.segmentedControl;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        return self.segmentedControl.frame.size.height;
    }
    return 0;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SSFLeftRightSwipeTableViewCell * cell = (SSFLeftRightSwipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell.isEditMode) {
        //到下一界面
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            self.selectedZDCustomer = self.filteredChanceCustomers[indexPath.row];
        } else {
           self.selectedZDCustomer = self.allChanceCustomers[indexPath.row];
        }
        [self performSegueWithIdentifier:@"ChanceCustomerDetail Display" sender:self];
    }
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChanceCustomerDetail Display"]) {
        ZDChanceCustomerDetailViewController * chanceCustomerDetailViewController = segue.destinationViewController;
        chanceCustomerDetailViewController.zdCustomer = self.selectedZDCustomer;
    } else if ([segue.identifier isEqualToString:@"addAndEdit Display"]) {
        ZDAddAndEditeViewController * addAndEditeViewController = segue.destinationViewController;
        addAndEditeViewController.delegate = self;
        if (self.selectedZDCustomer) {
            //编辑客户
            addAndEditeViewController.mode = ZDAddAndEditeViewControllerModeEdit;
            addAndEditeViewController.editedCustomer = self.selectedZDCustomer;
        } else {
            //新增客户
            addAndEditeViewController.mode = ZDAddAndEditeViewControllerModeAdd;
        }
    }
}

#pragma mark - SSFLeftRightSwipeTableViewCellDelegate

- (void)leftRightSwipeTableViewCellDeleteButtonPressed:(SSFLeftRightSwipeTableViewCell *)cell
{
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    ZDCustomer * zdCustomer = self.allChanceCustomers[index.row];
    
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
    self.selectedZDCustomer = self.allChanceCustomers[index.row];
    [self performSegueWithIdentifier:@"addAndEdit Display" sender:self];
}

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

#pragma mark - search display controller delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"customerName contains[cd] %@",searchString];
    self.filteredChanceCustomers = [self.allChanceCustomers filteredArrayUsingPredicate:predicate];
    return YES;
}

#pragma mark addAndEditView delegate

- (void)addAndEditeViewControllerDidFinishAdd:(ZDAddAndEditeViewController *)controller
{
    [self.navigationController popToViewController:self animated:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"添加成功";
    [hud hide:YES afterDelay:1];
}

- (void)addAndEditeViewControllerDidFinishEdit:(ZDAddAndEditeViewController *)controller
{
    [self.navigationController popToViewController:self animated:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"编辑成功";
    [hud hide:YES afterDelay:1];
}

@end
