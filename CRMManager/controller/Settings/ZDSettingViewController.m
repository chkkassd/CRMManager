//
//  ZDSettingViewController.m
//  CrmApp
//
//  Created by apple on 14-7-22.
//  Copyright (c) 2014年 com.zendai. All rights reserved.
//

#import "ZDSettingViewController.h"
#import "ZDSuggestionViewController.h"

@interface ZDSettingViewController () <UIAlertViewDelegate,ZDSuggestionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch * gesturePasswordSwitch;

@end

@implementation ZDSettingViewController

#pragma mark - Action

- (IBAction)loginOut:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号。"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"退出登录"
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (IBAction)gesturePasswordSwitchPressed:(id)sender
{
    BOOL flag = self.gesturePasswordSwitch.on;
    ZDManagerUser * zdManagerUser = [ZDModeClient sharedModeClient].zdManagerUser;
    zdManagerUser.gesturePasswordSwitch = flag;
    [[ZDModeClient sharedModeClient] saveZDManagerUser:zdManagerUser];
}

#pragma mark - UITableViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else if (section == 3) {
        return 40;
    } else {
        return 20;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setting To Suggsetion"]) {
        ZDSuggestionViewController * suggestionViewController = segue.destinationViewController;
        suggestionViewController.delegate = self;
    }
}

#pragma mark - suggestion view delegate

- (void)suggestionViewControllerDidFinishFeedBack:(ZDSuggestionViewController *)controller
{
    [self.navigationController popToViewController:self animated:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"提交成功";
    [hud hide:YES afterDelay:1];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        //若是正常退出，DefaultCurrentUserId清空，用户名和密码不清空,若非正常退出,DefaultCurrentUserId不清空
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:DefaultCurrentUserId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.delegate settingViewControllerDidLoginOut:self];
    }
}

@end
