//
//  ZDSettingViewController.m
//  CrmApp
//
//  Created by apple on 14-7-22.
//  Copyright (c) 2014年 com.zendai. All rights reserved.
//

#import "ZDSettingViewController.h"

@interface ZDSettingViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UISwitch * gesturePasswordSwitch;

@end

@implementation ZDSettingViewController

#pragma mark - Action

- (IBAction)loginOut:(id)sender
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"你好" message:@"确定退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
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
        return 15;
    } else if (section == 3) {
        return 40;
    } else {
        return 20;
    }
}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 1:
//                [self performSegueWithIdentifier:@"GesturePasswordSettingView Display" sender:self];
//                break;
//            default:
//                break;
//        }
//    } else if (indexPath.section == 1) {
//        switch (indexPath.row) {
//            case 0:
//                [self performSegueWithIdentifier:@"QAView Display" sender:self];
//                break;
//            case 1:
//                [self performSegueWithIdentifier:@"SugestionView Display" sender:self];
//                break;
//            default:
//                break;
//        }
//    }
//}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        //退出,nsuserdefaults清除保存的当前uesrid
        [[NSUserDefaults standardUserDefaults] setObject:Nil forKey:DefaultCurrentUserId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
