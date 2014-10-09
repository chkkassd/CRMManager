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
#import "ZDAddressBookTableViewController.h"

@interface ZDChanceViewController ()<SSFLeftRightSwipeTableViewCellDelegate,SSFSegmentControlDelegate,ZDAddAndEditeViewControllerDelegate>

@property (strong, nonatomic) SSFSegmentControl * segmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar * searchBar;
@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (weak, nonatomic) IBOutlet UIView * indicatorView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView * indicator;
@property (strong, nonatomic) NSArray * allChanceCustomers;
@property (strong, nonatomic) NSArray * sortedChanceCustomers;
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

- (void)checkNetAndShow:(BOOL)havenet
{
    if (!havenet) {
        self.title = @"机会(未连接)";
    } else {
        self.title = @"机会";
    }
}

#pragma mark - Action

- (IBAction)addButtonPressed:(id)sender
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"新增客户" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加",@"从通讯录导入", nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

- (NSArray *)sortedByHope:(NSInteger)hope
{
    switch (hope) {
        case 0:
        {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"cdHope == %@",@"3"];
            return [self.allChanceCustomers filteredArrayUsingPredicate:predicate];
            break;
        }
        case 1:
        {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"cdHope == %@",@"1"];
            return [self.allChanceCustomers filteredArrayUsingPredicate:predicate];
            break;
        }
        case 2:
        {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"cdHope == %@",@"2"];
            return [self.allChanceCustomers filteredArrayUsingPredicate:predicate];
            break;
        }
        case 3:
        {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"cdHope != %@ && cdHope != %@ && cdHope != %@",@"1",@"2",@"3"];
            return [self.allChanceCustomers filteredArrayUsingPredicate:predicate];
            break;
        }
        default:
            break;
    }
    return nil;
}

#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"新增客户"]) {
        NSString * buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:@"添加"]) {
            self.selectedZDCustomer = nil;
            [self performSegueWithIdentifier:@"addAndEdit Display" sender:self];
        } else if ([buttonTitle isEqualToString:@"从通讯录导入"]) {
            //做通讯录导入操作
            [self performSegueWithIdentifier:@"AddressBook Display" sender:self];
        }
    } else if ([actionSheet.title isEqualToString:@"拨号"]) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            if (self.selectedZDCustomer.mobile.length) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.selectedZDCustomer.mobile]]];
            }
        }
    }
}

#pragma mark - properties

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    _tableView.tableHeaderView = self.segmentedControl;
}

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
  
    self.sortedChanceCustomers = [self sortedByHope:self.segmentedControl.selectedIndex];
}

- (void)setSortedChanceCustomers:(NSArray *)sortedChanceCustomers
{
    _sortedChanceCustomers = sortedChanceCustomers;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filteredChanceCustomers.count;
    } else {
       return self.sortedChanceCustomers.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSFLeftRightSwipeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SSFLeftRightSwipeTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.realContentView.frame = cell.contentView.frame;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        ZDCustomer * zdFilterCustomer = self.filteredChanceCustomers[indexPath.row];
        cell.label.text = [zdFilterCustomer customerName];
        cell.headImageView.image = [UIImage headImageForZDCustomer:zdFilterCustomer andIsBig:NO];
    } else {
        ZDCustomer * zdCustomer = self.sortedChanceCustomers[indexPath.row];
       cell.label.text = [zdCustomer customerName];
        cell.headImageView.image = [UIImage headImageForZDCustomer:zdCustomer andIsBig:NO];
    }
    
    switch (self.segmentedControl.selectedIndex) {
        case 0:
            cell.interestLabel.text = @"意愿  一般";
            break;
        case 1:
            cell.interestLabel.text = @"意愿  强烈";
            break;
        case 2:
            cell.interestLabel.text = @"意愿  感兴趣";
            break;
        case 3:
            cell.interestLabel.text = @"意愿  待归类";
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
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
           self.selectedZDCustomer = self.sortedChanceCustomers[indexPath.row];
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
    ZDCustomer * zdCustomer = self.sortedChanceCustomers[index.row];
    
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
    self.selectedZDCustomer = self.sortedChanceCustomers[index.row];
    [self performSegueWithIdentifier:@"addAndEdit Display" sender:self];
}

- (void)leftRightSwipeTableViewCellTelephoneButtonPressed:(SSFLeftRightSwipeTableViewCell *)cell
{
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    self.selectedZDCustomer = self.sortedChanceCustomers[index.row];
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"拨号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"电话呼叫", nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - SSFSegmentControlDelegate

- (void)SSFSegmentControlDidPressed:(UIView *)view selectedIndex:(NSInteger)selectedIndex
{
    self.allChanceCustomers = [ZDModeClient sharedModeClient].allZDChanceCustomers;
}

#pragma mark - search display controller delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"customerName contains[cd] %@",searchString];
    self.filteredChanceCustomers = [self.allChanceCustomers filteredArrayUsingPredicate:predicate];
    return YES;
}

#pragma mark - scrollView delegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.y <= -30) {
        self.indicatorView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
        } completion:^(BOOL finished) {
            if (finished) {
                [self.indicator startAnimating];
                [[ZDModeClient sharedModeClient] refreshCustomersCompletionHandler:^(NSError *error) {
                   
                    [UIView animateWithDuration:0.2 animations:^{
                        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [self.indicator stopAnimating];
                            self.indicatorView.hidden = YES;
                        }
                    }];
                    
                    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    if (!error) {
                        hud.labelText = @"刷新成功";
                        [hud hide:YES afterDelay:1];
                    } else {
                        hud.labelText = @"刷新失败";
                        [hud hide:YES afterDelay:1];
                    }
                }];
            }
        }];
        
    }
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
