//
//  ZDGesturePasswordViewController.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDGesturePasswordViewController.h"
#import "ZDSelectAreaTableViewController.h"

@interface ZDGesturePasswordViewController ()<SSFPasswordGestureViewDelegate,ZDSelectAreaTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView * gestureContainView;
@property (weak, nonatomic) IBOutlet UIImageView * headImageView;
@property (weak, nonatomic) IBOutlet UILabel * alertLabel;
@property (strong, nonatomic) ZDManagerUser * zdManagerUser;
@property (strong, nonatomic) SSFPasswordGestureView * passwordGestureView;
@end

@implementation ZDGesturePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatSSFPasswordGestureView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self positonSSFPasswordView];
}

#pragma mark - methods

- (void)creatSSFPasswordGestureView
{
    self.passwordGestureView.delegate = self;
    self.passwordGestureView.gesturePassword = self.zdManagerUser.gesturePassword;
    if (!self.zdManagerUser.gesturePassword.length) {
        self.passwordGestureView.state = SSFPasswordGestureViewStateWillFirstDraw;
        self.alertLabel.text = @"请设置手势密码";
    } else {
        self.passwordGestureView.state = SSFPasswordGestureViewStateCheck;
        self.alertLabel.text = @"请输入手势密码";
    }
    [self.gestureContainView addSubview:self.passwordGestureView];
}

- (void)positonSSFPasswordView
{
    //兼容大小屏幕
    if (self.gestureContainView.frame.size.width >= self.gestureContainView.frame.size.height) {
        self.passwordGestureView.frame = CGRectMake(0, 0, self.gestureContainView.frame.size.height, self.gestureContainView.frame.size.height);
    } else {
        self.passwordGestureView.frame = CGRectMake(0, 0, self.gestureContainView.frame.size.width, self.gestureContainView.frame.size.width);
    }
    self.passwordGestureView.center = CGPointMake(self.gestureContainView.frame.size.width/2, self.gestureContainView.frame.size.height/2);
}

- (void)presentToSelectAreaView
{
    ZDSelectAreaTableViewController * savc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZDSelectAreaTableViewController"];
    savc.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:savc];
    [self presentViewController:nav animated:YES completion:NULL];
}

#pragma mark - action

- (IBAction)forgetPasswordButtonPressed:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定重新登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - properties

- (ZDManagerUser *)zdManagerUser
{
    if (!_zdManagerUser) {
        _zdManagerUser = [ZDModeClient sharedModeClient].zdManagerUser;
    }
    return _zdManagerUser;
}

- (SSFPasswordGestureView *)passwordGestureView
{
    if (!_passwordGestureView) {
        _passwordGestureView = [SSFPasswordGestureView instancePasswordView];
    }
    return _passwordGestureView;
}

#pragma mark - alert delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"输入错误"]) {
        //输入5次错误
        if (buttonIndex == alertView.cancelButtonIndex) {
            //将手势密码置空
            self.zdManagerUser.gesturePassword = @"";
            [[ZDModeClient sharedModeClient] saveZDManagerUser:self.zdManagerUser];
            //置空，忘记密码默认为安全推出
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:DefaultCurrentUserId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.delegate gesturePasswordViewControllerDidForgetGesturePassword:self];
        }
    } else {
        //忘记手势密码
        if (buttonIndex != alertView.cancelButtonIndex) {
            //将手势密码置空
            self.zdManagerUser.gesturePassword = @"";
            [[ZDModeClient sharedModeClient] saveZDManagerUser:self.zdManagerUser];
            //置空，忘记密码默认为安全推出
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:DefaultCurrentUserId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.delegate gesturePasswordViewControllerDidForgetGesturePassword:self];
        }
    }
}

#pragma mark - SSFPasswordGestureViewDelegate

- (void)passwordGestureViewFinishFirstTimePassword:(SSFPasswordGestureView *)passwordView
{
    self.alertLabel.text = @"请再次输入手势密码";
    self.alertLabel.textColor = [UIColor colorWithRed:197/255.0 green:237/255.0 blue:255/255.0 alpha:1.0];
}

- (void)passwordGestureViewFinishSecondTimePassword:(SSFPasswordGestureView *)passwordView andPassword:(NSString *)password
{
    self.alertLabel.text = @"手势密码设置成功";
    self.alertLabel.textColor = [UIColor colorWithRed:197/255.0 green:237/255.0 blue:255/255.0 alpha:1.0];
    
    self.zdManagerUser.gesturePassword = password;
    [[ZDModeClient sharedModeClient] saveZDManagerUser:self.zdManagerUser];
    
    if (!self.zdManagerUser.areaid.length) {
        [self presentToSelectAreaView];
    }
}

- (void)passwordGestureViewFinishWrongPassword:(SSFPasswordGestureView *)passwordView
{
    self.alertLabel.text = @"两次密码不同,请重设密码";
    self.alertLabel.textColor = [UIColor colorWithRed:239/255.0 green:97/255.0 blue:97/255.0 alpha:1.0];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{
        self.alertLabel.transform = CGAffineTransformMakeRotation(0.1);
    } completion:^(BOOL finished) {
        self.alertLabel.transform = CGAffineTransformMakeRotation(0);
    }];
}

- (void)passwordGestureViewFinishCheckPassword:(SSFPasswordGestureView *)passwordView
{
    [self.delegate gesturePasswordViewControllerDidFinish:self];
}

- (void)passwordGestureViewCheckPasswordWrong:(SSFPasswordGestureView *)passwordView andInputCount:(NSInteger)count
{
    if (count > 0) {
        self.alertLabel.text = [NSString stringWithFormat:@"手势密码错误,还剩%d次机会",count];
    } else {
        self.alertLabel.text = @"手势密码错误";
        [[[UIAlertView alloc] initWithTitle:@"输入错误" message:@"手势密码错误过多,已解除,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }
    
    self.alertLabel.textColor = [UIColor colorWithRed:239/255.0 green:97/255.0 blue:97/255.0 alpha:1.0];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{
        self.alertLabel.transform = CGAffineTransformMakeRotation(0.1);
    } completion:^(BOOL finished) {
        self.alertLabel.transform = CGAffineTransformMakeRotation(0);
    }];
}

#pragma mark - Select area view delegate

- (void)selectAreaTableViewControllerDidFinishSelectArea:(ZDSelectAreaTableViewController *)controller
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        [self.delegate gesturePasswordViewControllerDidFinish:self];
    }];
    
}

@end
