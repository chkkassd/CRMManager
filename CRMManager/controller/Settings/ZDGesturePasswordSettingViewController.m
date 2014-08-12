//
//  ZDGesturePasswordSettingViewController.m
//  CRMManager
//
//  Created by peter on 14-8-12.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDGesturePasswordSettingViewController.h"

@interface ZDGesturePasswordSettingViewController ()<SSFPasswordGestureViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel * alertLabel;
@property (strong, nonatomic) ZDManagerUser * zdManagerUser;

@end

@implementation ZDGesturePasswordSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)configureView
{
    SSFPasswordGestureView * passwordGestureView = [SSFPasswordGestureView instancePasswordView];
    passwordGestureView.delegate = self;
    passwordGestureView.state = SSFPasswordGestureViewStateWillFirstDraw;
    passwordGestureView.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
    [self.view addSubview:passwordGestureView];
    self.alertLabel.text = @"绘制解锁图案";
    
    if (!self.zdManagerUser.gesturePasswordSwitch) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"你好" message:@"手势密码已关闭" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

#pragma mark - properties

- (ZDManagerUser *)zdManagerUser
{
    if (!_zdManagerUser) {
        _zdManagerUser = [ZDModeClient sharedModeClient].zdManagerUser;
    }
    return _zdManagerUser;
}

#pragma mark - SSFPasswordGestureViewDelegate

- (void)passwordGestureViewFinishFirstTimePassword:(SSFPasswordGestureView *)passwordView
{
    self.alertLabel.text = @"请再次绘制解锁图案";
}

- (void)passwordGestureViewFinishSecondTimePassword:(SSFPasswordGestureView *)passwordView andPassword:(NSString *)password
{
    ZDManagerUser * zdManagerUser = [ZDModeClient sharedModeClient].zdManagerUser;
    zdManagerUser.gesturePassword = password;
    //保存到数据库
    if ([[ZDModeClient sharedModeClient] saveZDManagerUser:zdManagerUser]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"手势密码修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)passwordGestureViewFinishWrongPassword:(SSFPasswordGestureView *)passwordView
{
    self.alertLabel.text = @"两次绘制不相同,请重新绘制第二次图案";
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
