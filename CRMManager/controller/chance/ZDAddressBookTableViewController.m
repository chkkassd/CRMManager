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

@interface ZDAddressBookTableViewController ()

@property (strong, nonatomic) NSArray * allAddressBookFriends;
@property (strong, nonatomic) NSArray * filterdFriends;

@end

@implementation ZDAddressBookTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
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
        thisFriend = CFBridgingRetain(self.allAddressBookFriends[indexPath.row]);
        NSString * firstName = CFBridgingRelease(ABRecordCopyValue(thisFriend, kABPersonFirstNameProperty));
        NSString * lastName = CFBridgingRelease(ABRecordCopyValue(thisFriend, kABPersonLastNameProperty));
        NSString * name1 = lastName.length ? lastName : @"";
        NSString * name2 = firstName.length ? firstName : @"";
        cell.nameLabel.text = [NSString stringWithFormat:@"%@%@",name1,name2];
        CFRelease(thisFriend);
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
}

#pragma mark - searchDispaly delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.filterdFriends = [self filterFriendsWithContents:searchString];
    return YES;
}

@end
