//
//  ZDChanceViewController.m
//  CRMManager
//
//  Created by peter on 14-8-18.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDChanceViewController.h"
#import "ZDChanceCustomerDetailViewController.h"

@interface ZDChanceViewController ()<SSFLeftRightSwipeTableViewCellDelegate,SSFSegmentControlDelegate>

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
    
//    ZDCustomer * c1 = [[ZDCustomer alloc] init];
//    c1.customerName = @"peter";
//    ZDCustomer * c2 = [[ZDCustomer alloc] init];
//    c2.customerName = @"jack";
//    self.allChanceCustomers = @[c1,c2];
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
        cell.label.text = [self.filteredChanceCustomers[indexPath.row] customerName];
    } else {
       cell.label.text = [self.allChanceCustomers[indexPath.row] customerName];
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
//            [self searchDisplayPushToCustomerDetailView];
        } else {
           self.selectedZDCustomer = self.allChanceCustomers[indexPath.row];
        }
        [self performSegueWithIdentifier:@"ChanceCustomerDetail Display" sender:self];
    }
}

//- (void)searchDisplayPushToCustomerDetailView
//{
//    ZDChanceCustomerDetailViewController * chanceCustomerDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ZDChanceCustomerDetailViewController"];
//    chanceCustomerDetailViewController.zdCustomer = self.selectedZDCustomer;
//
//    [self.searchDisplayController.searchContentsController.navigationController pushViewController:chanceCustomerDetailViewController animated:YES];
//}

#pragma mark - segure

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChanceCustomerDetail Display"]) {
        ZDChanceCustomerDetailViewController * chanceCustomerDetailViewController = segue.destinationViewController;
        chanceCustomerDetailViewController.zdCustomer = self.selectedZDCustomer;
    }
}

#pragma mark - SSFLeftRightSwipeTableViewCellDelegate

- (void)leftRightSwipeTableViewCellDeleteButtonPressed:(SSFLeftRightSwipeTableViewCell *)cell
{}

- (void)leftRightSwipeTableViewCellEditeButtonPressed:(SSFLeftRightSwipeTableViewCell *)cell
{}

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

@end
