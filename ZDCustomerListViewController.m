//
//  ZDCustomerDetailViewController.m
//  CRMManager
//
//  Created by peter on 14-8-26.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDCustomerListViewController.h"
#import "ZDCustomerListTableViewCell.h"

@interface ZDCustomerListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) NSArray* listItem;

@end

@implementation ZDCustomerListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.listItem = @[@{
                        @"image": @"ico_currentClient_detail",
                        @"labelName": @"详细信息"
                      },
                      @{
                          @"image": @"ico_currentClient_invest",
                          @"labelName": @"理财记录"
                      },
                      @{
                          @"image": @"ico_currentClient_contact",
                          @"labelName": @"联系记录"
                      }
                      ];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZDCustomerListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"customer list cell" forIndexPath:indexPath];
    
    cell.label.text = self.listItem[indexPath.row][@"labelName"];
    cell.imageViewFirst.image = [UIImage imageNamed:self.listItem[indexPath.row][@"image"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"Show Detail" sender:self];
    } else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"Show Record" sender:self];
    }
}

@end
