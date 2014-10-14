//
//  ZDCustomerBusinessTableViewController.m
//  CRMManager
//
//  Created by peter on 14-8-26.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDCustomerBusinessTableViewController.h"
#import "ZDCustomerBusinessTableViewCellNormal.h"
#import "ZDCustomerBusinessTableViewCellUnfold.h"

@interface ZDCustomerBusinessTableViewController ()

@property (strong, nonatomic) NSArray * businessLists;
@property (strong, nonatomic) NSMutableArray * dataBusinessLists;
@property (strong, nonatomic) NSDictionary * CRMStateDictionary;
@property (strong, nonatomic) NSDictionary * fortuneStateDictionary;

@end

@implementation ZDCustomerBusinessTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBusinessLists:) name:ZDUpdateBusinessAndBusinessListsNotification object:[ZDModeClient sharedModeClient]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshBusinessListView) forControlEvents:UIControlEventValueChanged];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - methods

- (void)updateBusinessLists:(NSNotification *)noti
{
    self.businessLists = [[ZDModeClient sharedModeClient] zdBusinessListsWithCustomerId:_customer.customerId];
}

- (void)refreshBusinessListView
{
    [[ZDModeClient sharedModeClient] fetchAndSaveAllBusinessListsWithManagerId:[ZDModeClient sharedModeClient].zdManagerUser.userid completionHandler:^(NSError *error) {
        [self.refreshControl endRefreshing];
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (!error) {
            hud.labelText = @"刷新成功";
            self.businessLists = [[ZDModeClient sharedModeClient] zdBusinessListsWithCustomerId:_customer.customerId];
            [hud hide:YES afterDelay:1];
        } else {
            hud.labelText = @"刷新失败";
            [hud hide:YES afterDelay:1];
        }
    }];
}

- (UIColor *)backgroundColorForNormalCellWithIndex:(NSInteger)index
{
    NSArray * colors = @[[UIColor colorWithRed:33/255.0 green:133/255.0 blue:196/255.0 alpha:1.0],
                         [UIColor colorWithRed:53/255.0 green:162/255.0 blue:211/255.0 alpha:1.0],
                         [UIColor colorWithRed:237/255.0 green:157/255.0 blue:63/255.0 alpha:1.0],
                         [UIColor colorWithRed:41/255.0 green:205/255.0 blue:157/255.0 alpha:1.0]];
    NSInteger a = (index + 1) % 4;
    switch (a) {
        case 1:
            return colors[0];
            break;
        case 2:
            return colors[1];
            break;
        case 3:
            return colors[2];
            break;
        case 0:
            return colors[3];
            break;
        default:
            break;
    }
    return colors[0];//默认色
}

- (NSString *)stateStringWithBusinessList:(ZDBusinessList *)zdBusinessList
{
    NSString * crmState = zdBusinessList.crmState;
    NSString * fortuneState = zdBusinessList.fortuneState;
    if (fortuneState.length == 0) {
        return self.CRMStateDictionary[crmState];
    } else if (([crmState isEqualToString:@"4"] || [crmState isEqualToString:@"7"] || [crmState isEqualToString:@"8"] || [crmState isEqualToString:@"9"]) && ([fortuneState isEqualToString:@"02000009"] || [fortuneState isEqualToString:@"02000010"] || [fortuneState isEqualToString:@"02000014"] || [fortuneState isEqualToString:@"02000013"])) {
        return @"投资生效";
    } else {
        return self.fortuneStateDictionary[fortuneState];
    }
}
/*
- (NSString *)reciprocalDateStringwithTime:(NSTimeInterval)time
{
    if (time <= 60 * 60) {
        return nil;
    } else if (time > 60 * 60 && time <= 60 * 60 * 24) {
        int hour = floor(time/3600);
        return [NSString stringWithFormat:@"%d小时",hour];
    } else {
        int day = floor(time/(24 * 60 * 60));
        int hour = floor((time - day * 24 * 60 * 60)/(60 * 60));
        return [NSString stringWithFormat:@"%d天%d小时",day,hour];
    }
}
*/
- (NSString *)reciprocalDateStringFromNowTime:(NSDate *)nowDate toEndTime:(NSDate *)endDate
{
    NSCalendar * calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents * dateComponents = [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:nowDate toDate:endDate options:0];
//    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
        if (month > 0) {
            if (day > 0) {
                return [NSString stringWithFormat:@"倒数%ld月%ld天",(long)month,(long)day];
            } else {
                return [NSString stringWithFormat:@"倒数%ld月",(long)month];
            }
        } else {
            if (day > 0) {
                return [NSString stringWithFormat:@"倒数%ld天",(long)day];
            } else return @"";
        }
}

#pragma mark - properties

- (void)setCustomer:(ZDCustomer *)customer
{
    _customer = customer;
    self.businessLists = [[ZDModeClient sharedModeClient] zdBusinessListsWithCustomerId:_customer.customerId];
}

- (void)setBusinessLists:(NSArray *)businessLists
{
    _businessLists = businessLists;
    
    self.dataBusinessLists = [[NSMutableArray alloc] init];
    for (ZDBusinessList * obj in _businessLists) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"normal",@"cell",@"NO",@"isUnfold",obj,@"object", nil];//@{@"cell": @"normal",
                               //@"isUnfold": @"NO",
                               //@"object": obj};
        [self.dataBusinessLists addObject:dic];
    }
    [self.tableView reloadData];
}

//- (void)setDataBusinessLists:(NSMutableArray *)dataBusinessLists
//{
//    _dataBusinessLists = [dataBusinessLists mutableCopy];
//    [self.tableView reloadData];
//}

- (NSDictionary *)CRMStateDictionary
{
    if (!_CRMStateDictionary) {
        NSString * crmStatePath = [[ZDCachePathUtility sharedCachePathUtility] pathForCRMState];
        if ([[NSFileManager defaultManager] fileExistsAtPath:crmStatePath]) {
            _CRMStateDictionary = [NSDictionary dictionaryWithContentsOfFile:crmStatePath];
        }
    }
    return _CRMStateDictionary;
}

- (NSDictionary *)fortuneStateDictionary
{
    if (!_fortuneStateDictionary) {
        NSString * fortuneStatePath = [[ZDCachePathUtility sharedCachePathUtility] pathForFortuneState];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fortuneStatePath]) {
            _fortuneStateDictionary = [NSDictionary dictionaryWithContentsOfFile:fortuneStatePath];
        }
    }
    return _fortuneStateDictionary;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataBusinessLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.dataBusinessLists[indexPath.row] objectForKey:@"cell"] isEqualToString:@"normal"]) {
        return 133.0;
    } else {
        return 167.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZDBusinessList * zdBusinessList = [self.dataBusinessLists[indexPath.row] objectForKey:@"object"];
    ZDInvestmentRemind * zdInvestmentRemind = [[ZDModeClient sharedModeClient] investmentRemindWithCustomerId:self.customer.customerId andFeLendNo:zdBusinessList.feLendNo];
    
    if ([[self.dataBusinessLists[indexPath.row] objectForKey:@"cell"] isEqualToString:@"normal"]) {
        ZDCustomerBusinessTableViewCellNormal * cell = [tableView dequeueReusableCellWithIdentifier:@"businessNomalCell" forIndexPath:indexPath];
        cell.productNameLabel.text = zdBusinessList.pattern;
        cell.numberLabel.text = zdBusinessList.feLendNo;
        cell.backGroundView.backgroundColor = [self backgroundColorForNormalCellWithIndex:indexPath.row];
        if (zdInvestmentRemind) {
            cell.alertImageView.hidden = NO;
        } else {
            cell.alertImageView.hidden = YES;
        }
        
        return cell;
    } else {
        ZDCustomerBusinessTableViewCellUnfold * cell = [tableView dequeueReusableCellWithIdentifier:@"businessUnfoldCell" forIndexPath:indexPath];
        cell.moneyLabel.text = zdBusinessList.investAmt;
        
        NSString * stateString = [self stateStringWithBusinessList:zdBusinessList];
        cell.stateLabel.text = stateString;
        cell.dateLabel.text = zdBusinessList.endDate.length ? [zdBusinessList.endDate substringToIndex:10] : @"";
       
        if (zdInvestmentRemind) {
            cell.reciprocalDateLabel.hidden = NO;
            NSDate * endDate = [NSString convertDateFromString:zdBusinessList.endDate];
            NSDate * nowDate = [NSDate date];
            NSString * reciprocalString = [self reciprocalDateStringFromNowTime:nowDate toEndTime:endDate];
            if (reciprocalString.length) {
                cell.reciprocalDateLabel.text = reciprocalString;
            } else {
                cell.reciprocalDateLabel.hidden = YES;
                //已到期的投资提醒,在本地数据库中删除
                [[ZDModeClient sharedModeClient] deleteInvestmentRemindWithZDInvestmentRemind:zdInvestmentRemind];
            }
        } else {
            cell.reciprocalDateLabel.hidden = YES;
        }
        
        return cell;
    }
}

#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZDBusinessList * zdBusinessList = [self.dataBusinessLists[indexPath.row] objectForKey:@"object"];
    NSIndexPath * index = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
    
    //只允许点击normalCell
    if ([[self.dataBusinessLists[indexPath.row] objectForKey:@"cell"] isEqualToString:@"normal"]) {
        //获得已展开的cell
        NSIndexPath * isIndex = nil;
        for (NSDictionary * dic in self.dataBusinessLists) {
            if ([dic[@"cell"] isEqualToString:@"unfold"]) {
                isIndex = [NSIndexPath indexPathForRow:[self.dataBusinessLists indexOfObject:dic] inSection:0];
            }
        }
        
        if ([[self.dataBusinessLists[indexPath.row] objectForKey:@"isUnfold"] isEqualToString:@"YES"]) {
            //已展开
            [self.dataBusinessLists[indexPath.row] setObject:@"NO" forKey:@"isUnfold"];
            [self.dataBusinessLists removeObjectAtIndex:index.row];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationMiddle];
            [tableView endUpdates];
        } else {
            //未展开
            NSDictionary * dic = @{@"cell": @"unfold",
                                   @"object": zdBusinessList};
            
            if (isIndex) {
                //有已展开的cell
                [self.dataBusinessLists removeObjectAtIndex:isIndex.row];
                if (indexPath.row > isIndex.row) {
                    [self.dataBusinessLists insertObject:dic atIndex:index.row - 1];
                    [self.dataBusinessLists[indexPath.row - 1] setObject:@"YES" forKey:@"isUnfold"];
                    [self.dataBusinessLists[isIndex.row - 1] setObject:@"NO" forKey:@"isUnfold"];
                    index = [NSIndexPath indexPathForRow:index.row - 1 inSection:0];
                } else {
                    [self.dataBusinessLists insertObject:dic atIndex:index.row];
                    [self.dataBusinessLists[indexPath.row] setObject:@"YES" forKey:@"isUnfold"];
                    [self.dataBusinessLists[isIndex.row] setObject:@"NO" forKey:@"isUnfold"];
                }
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:@[isIndex] withRowAnimation:UITableViewRowAnimationMiddle];
                [tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationMiddle];
                [tableView endUpdates];
            } else {
                //没有已展开的cell
                [self.dataBusinessLists insertObject:dic atIndex:index.row];
                [self.dataBusinessLists[indexPath.row] setObject:@"YES" forKey:@"isUnfold"];
                [tableView beginUpdates];
                [tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationMiddle];
                [tableView endUpdates];
            }
        }
    }
}

@end
