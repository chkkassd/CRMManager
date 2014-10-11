//
//  ZDAddressBookTableViewController.m
//  CRMManager
//
//  Created by peter on 14-8-28.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDAddressBookTableViewController.h"
#import "ZDAddressBookTableViewCell.h"
#import "ZDFilterdAddressBookTableViewCell.h"
#import "ZDAddAndEditeViewController.h"

@interface ZDAddressBookTableViewController ()<ZDAddressBookTableViewCellDelegate,ZDFilterdAddressBookTableViewCellDelegate,ZDAddAndEditeViewControllerDelegate>

@property (strong, nonatomic) NSArray * allAddressBookFriends;
@property (strong, nonatomic) NSArray * filterdFriends;
@property (strong, nonatomic) NSDictionary * infoDic;
@property (weak, nonatomic) IBOutlet UISearchBar * searchBar;

@end

@implementation ZDAddressBookTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

#pragma mark - properties

- (void)setAllAddressBookFriends:(NSArray *)allAddressBookFriends
{
    _allAddressBookFriends = allAddressBookFriends;
    [self.tableView reloadData];
}

#pragma mark - methods

- (void)configureView
{
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"ZDFilterdAddressBookTableViewCell" bundle:nil] forCellReuseIdentifier:@"filterdAddressBookCell"];
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        if (granted) {
            //已被授权
            self.allAddressBookFriends = [self filterFriendsWithContents:@""];
        }
        CFRelease(addressBookRef);//coreFundation不受arc管理，需手动释放
    });
}

- (NSArray *)filterFriendsWithContents:(NSString *)string
{
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) return nil;
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    NSArray * friends = nil;
    if (!string.length) {
        //所有通讯录人员
        friends = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBookRef));
    } else {
        //根据通讯录人员名字来查找
        CFStringRef cfString = (CFStringRef)CFBridgingRetain(string);
        friends = CFBridgingRelease(ABAddressBookCopyPeopleWithName(addressBookRef, cfString));
        CFRelease(cfString);
    }
    CFRelease(addressBookRef);
    return friends;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filterdFriends.count;
    } else {
        return self.allAddressBookFriends.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABRecordRef thisFriend;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
       ZDFilterdAddressBookTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"filterdAddressBookCell" forIndexPath:indexPath];
        cell.delegate = self;
        thisFriend = CFBridgingRetain(self.filterdFriends[indexPath.row]);
        NSString * firstName = CFBridgingRelease(ABRecordCopyValue(thisFriend, kABPersonFirstNameProperty));
        NSString * lastName = CFBridgingRelease(ABRecordCopyValue(thisFriend, kABPersonLastNameProperty));
        NSString * name1 = lastName.length ? lastName : @"";
        NSString * name2 = firstName.length ? firstName : @"";
        cell.nameLabel.text = [NSString stringWithFormat:@"%@%@",name1,name2];
        CFRelease(thisFriend);
        return cell;
    } else {
       ZDAddressBookTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"addressBookCell" forIndexPath:indexPath];
        cell.delegate = self;
        thisFriend = CFBridgingRetain(self.allAddressBookFriends[indexPath.row]);
        NSString * firstName = CFBridgingRelease(ABRecordCopyValue(thisFriend, kABPersonFirstNameProperty));
        NSString * lastName = CFBridgingRelease(ABRecordCopyValue(thisFriend, kABPersonLastNameProperty));
        cell.nameLabel.text = [NSString stringWithFormat:@"%@%@",lastName.length ? lastName : @"",firstName.length ? firstName : @""];
        CFRelease(thisFriend);
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addressBook To AddAndEdite"]) {
        ZDAddAndEditeViewController * addAndEditeViewController = segue.destinationViewController;
        addAndEditeViewController.delegate = self;
        addAndEditeViewController.mode = ZDAddAndEditeViewControllerModeAdd;
        addAndEditeViewController.infoDic = self.infoDic;
    }
}

#pragma mark - searchDispaly delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.filterdFriends = [self filterFriendsWithContents:searchString];
    return YES;
}

#pragma mark - ZDAddressBookCell delegate

- (void)addressBookTableViewCellAddButtonPressed:(ZDAddressBookTableViewCell *)cell
{
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    ABRecordRef theFriend = CFBridgingRetain(self.allAddressBookFriends[index.row]);
    NSString * firstName = CFBridgingRelease(ABRecordCopyValue(theFriend, kABPersonFirstNameProperty));
    NSString * lastName = CFBridgingRelease(ABRecordCopyValue(theFriend, kABPersonLastNameProperty));
    CFRelease(theFriend);
    
    NSString * mobile = [self fetchMobileWithPersonAtIndex:index.row withSearchText:@""];
    
    if (mobile.length) {
        self.infoDic = @{@"name": [NSString stringWithFormat:@"%@%@",lastName.length ? lastName : @"",firstName.length ? firstName : @""],
                         @"mobile": mobile};
        [self performSegueWithIdentifier:@"addressBook To AddAndEdite" sender:self];
    } else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"此用户没有联系电话,无法添加为储备客户" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }
}

//获取手机，为多值属性获取
- (NSString *)fetchMobileWithPersonAtIndex:(NSInteger)index withSearchText:(NSString *)searchText
{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    NSArray * friends;
    if (!searchText.length) {
        friends = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBookRef));
    } else {
        CFStringRef cfString = (CFStringRef)CFBridgingRetain(searchText);
        friends = CFBridgingRelease(ABAddressBookCopyPeopleWithName(addressBookRef, cfString));
        CFRelease(cfString);
    }

    ABRecordRef friend = CFBridgingRetain((friends[index]));
    
    ABMutableMultiValueRef phoneNumberProperty = ABRecordCopyValue(friend, kABPersonPhoneProperty);
    NSArray * phoneNumberArray = CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(phoneNumberProperty));
    for (int i = 0;i <phoneNumberArray.count; i++) {
        NSString * phoneLabel = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phoneNumberProperty, i));
        if ([phoneLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel] || [phoneLabel isEqualToString:(NSString *)kABPersonPhoneIPhoneLabel] || [phoneLabel isEqualToString:(NSString *)kABPersonPhoneMainLabel]  || [phoneLabel isEqualToString:(NSString *)kABPersonPhoneHomeFAXLabel] || [phoneLabel isEqualToString:(NSString *)kABPersonPhoneWorkFAXLabel] || [phoneLabel isEqualToString:(NSString *)kABPersonPhoneOtherFAXLabel] || [phoneLabel isEqualToString:(NSString *)kABPersonPhonePagerLabel] || [phoneLabel isEqualToString:(NSString *)kABWorkLabel] || [phoneLabel isEqualToString:(NSString *)kABHomeLabel]) {
            CFRelease(friend);
            CFRelease(addressBookRef);
            CFRelease(phoneNumberProperty);
            return phoneNumberArray[i];
            break;
        }
    }
    CFRelease(friend);
    CFRelease(addressBookRef);
    CFRelease(phoneNumberProperty);
    return nil;
}

#pragma mark - ZDFilterdAddressBookCell delegate

- (void)filterdAddressBookTableViewCellAddButtonPreseed:(ZDFilterdAddressBookTableViewCell *)cell
{
    NSIndexPath * index = [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
    ABRecordRef theFriend = CFBridgingRetain(self.filterdFriends[index.row]);
    NSString * firstName = CFBridgingRelease(ABRecordCopyValue(theFriend, kABPersonFirstNameProperty));
    NSString * lastName = CFBridgingRelease(ABRecordCopyValue(theFriend, kABPersonLastNameProperty));
    CFRelease(theFriend);
    
    NSString * mobile = [self fetchMobileWithPersonAtIndex:index.row withSearchText:self.searchBar.text];
    
    if (mobile.length) {
        self.infoDic = @{@"name": [NSString stringWithFormat:@"%@%@",lastName.length ? lastName : @"",firstName.length ? firstName : @""],
                         @"mobile": mobile};
        [self performSegueWithIdentifier:@"addressBook To AddAndEdite" sender:self];
    } else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"此用户没有联系电话,无法添加为储备客户" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }
}

#pragma mark - add and edite view delegate

- (void)addAndEditeViewControllerDidFinishAdd:(ZDAddAndEditeViewController *)controller
{
    [self.navigationController popToViewController:self animated:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"添加成功";
    [hud hide:YES afterDelay:1];
}

@end
