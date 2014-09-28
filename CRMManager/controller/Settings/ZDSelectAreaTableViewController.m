//
//  ZDSelectAreaTableViewController.m
//  CRMManager
//
//  Created by peter on 14-9-17.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDSelectAreaTableViewController.h"
#import "ZDSelectAreaTableViewCell.h"

@interface ZDSelectAreaTableViewController ()

@property (strong, nonatomic) NSArray * areaArr;
@property (strong, nonatomic) NSMutableArray * checkArr;
@property (strong, nonatomic) ZDManagerUser * zdManager;

@end

@implementation ZDSelectAreaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    [[ZDModeClient sharedModeClient] fetchAreaParamsCompletionHandler:^(NSError *error, NSArray *areas) {
        if (!error) {
            self.areaArr = areas;
            [hud hide:YES afterDelay:1];
            [self.tableView reloadData];
        } else {
            hud.labelText = @"加载失败,请稍候再试";
            [hud hide:YES afterDelay:1];
        }
    }];
}

#pragma mark - properties

- (ZDManagerUser *)zdManager
{
    if (!_zdManager) {
        _zdManager = [ZDModeClient sharedModeClient].zdManagerUser;
    }
    return _zdManager;
}

- (void)setAreaArr:(NSArray *)areaArr
{
    _areaArr = areaArr;
    self.checkArr = [[NSMutableArray alloc] init];
    for (int i = 0;i < areaArr.count; i++) {
        [self.checkArr addObject:@"0"];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.areaArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZDSelectAreaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectAreaCell" forIndexPath:indexPath];
    NSDictionary *dic = self.areaArr[indexPath.row];
    cell.textLab.text = dic[@"prName"];
    
    if ([self.checkArr[indexPath.row] isEqualToString:@"1"]) {
        UIView * view = [[UIView alloc] initWithFrame:cell.contentView.frame];
        UIImageView * checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_check"]];
        checkImageView.frame = CGRectMake(280, 20, 20, 20);
        [view addSubview:checkImageView];
        cell.backgroundView = view;
    } else {
        cell.backgroundView = nil;
    }
    
    return cell;
}

#pragma makr - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.checkArr[indexPath.row] = @"1";
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    NSDictionary *dic = self.areaArr[indexPath.row];
    self.zdManager.area = dic[@"prName"];
    self.zdManager.areaid = dic[@"prValue"];
    [[ZDModeClient sharedModeClient] saveZDManagerUser:self.zdManager];
    [self performSelector:@selector(backToPresent) withObject:nil afterDelay:1];
}

- (void)backToPresent
{
    [self.delegate selectAreaTableViewControllerDidFinishSelectArea:self];
}

@end
