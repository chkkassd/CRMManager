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
}

#pragma mark - properties

- (ZDManagerUser *)zdManagerUser
{
    if (!_zdManagerUser) {
        _zdManagerUser = [ZDModeClient sharedModeClient].zdManagerUser;
    }
    return _zdManagerUser;
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex) {
        [self.delegate gesturePasswordSettingViewControllerDidFinishPassword:self];
    }
}

#pragma mark - SSFPasswordGestureViewDelegate

- (void)passwordGestureViewFinishFirstTimePassword:(SSFPasswordGestureView *)passwordView
{
    self.alertLabel.text = @"请再次绘制解锁图案";
    self.alertLabel.textColor = [UIColor colorWithRed:197/255.0 green:237/255.0 blue:255/255.0 alpha:1.0];
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
    self.alertLabel.text = @"两次绘制不同,请重绘手势图案";
    self.alertLabel.textColor = [UIColor colorWithRed:239/255.0 green:97/255.0 blue:97/255.0 alpha:1.0];
}

@end
