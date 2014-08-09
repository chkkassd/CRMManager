//
//  ZDSettingViewController.m
//  CrmApp
//
//  Created by apple on 14-7-22.
//  Copyright (c) 2014年 com.zendai. All rights reserved.
//

#import "ZDSettingViewController.h"
//#import "ZDLoginStore.h"
//#import "ZDGestureLoginViewController.h"

@interface ZDSettingViewController () <UIAlertViewDelegate>

@end

@implementation ZDSettingViewController

- (IBAction)logout:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"注销" message:@"确定要注销码？" delegate:self cancelButtonTitle:@"不要" otherButtonTitles:@"是的", nil];
    [alert show];
    
}

#pragma mark - UIAlertViewDelegate

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        
//        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_ID];
//        self.view.window.rootViewController = [ZDLoginStore sharedStore].rootLoginViewController;
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 3 && indexPath.row == 0) {
//        ZDGestureLoginViewController *gestureViewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"GestureLoginViewController"];
//        gestureViewController.gestureViewState = SSFPasswordGestureViewStateWillFirstDraw;
//        [self presentViewController:gestureViewController animated:YES completion:^{
//            
//        }];
//    }
//}

@end
