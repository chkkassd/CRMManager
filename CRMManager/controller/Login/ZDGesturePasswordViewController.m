//
//  ZDGesturePasswordViewController.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDGesturePasswordViewController.h"
#import "ZDTabBarViewController.h"

#define DefaultCurrentGesturePasswordKey   @"DefaultCurrentGesturePassword"

@interface ZDGesturePasswordViewController ()<SSFPasswordGestureViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) IBOutlet UILabel * alertLabel;
@property (strong, nonatomic) ZDManagerUser * zdManagerUser;

@end

@implementation ZDGesturePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureGesturePasswordView];
}

- (void)configureGesturePasswordView
{
    SSFPasswordGestureView * passwordGestureView = [SSFPasswordGestureView instancePasswordView];
    passwordGestureView.delegate = self;
    passwordGestureView.gesturePassword = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultCurrentGesturePasswordKey];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:DefaultCurrentGesturePasswordKey] && !self.zdManagerUser.gesturePassword.length) {
        passwordGestureView.state = SSFPasswordGestureViewStateWillFirstDraw;
        self.alertLabel.text = @"请设置手势密码";
    } else {
        passwordGestureView.state = SSFPasswordGestureViewStateCheck;
        self.alertLabel.text = @"请输入手势密码";
    }
    passwordGestureView.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    [self.view addSubview:passwordGestureView];
    
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
    self.alertLabel.text = @"请再次输入手势密码";
}

- (void)passwordGestureViewFinishSecondTimePassword:(SSFPasswordGestureView *)passwordView andPassword:(NSString *)password
{
    self.alertLabel.text = @"手势密码设置成功";
    self.zdManagerUser.gesturePassword = password;
    [[ZDModeClient sharedModeClient] saveZDManagerUser:self.zdManagerUser];
    [self performSelector:@selector(presentToMainController) withObject:nil afterDelay:1.0];
}

- (void)presentToMainController
{
    ZDTabBarViewController * tabBarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ZDTabBarViewController"];
    [self presentViewController:tabBarViewController animated:YES completion:NULL];
}

- (void)passwordGestureViewFinishWrongPassword:(SSFPasswordGestureView *)passwordView
{
    self.alertLabel.text = @"两次密码不相同,请输入第二次手势密码";
}

- (void)passwordGestureViewFinishCheckPassword:(SSFPasswordGestureView *)passwordView
{
//    NSString *pd = self.zdManagerUser.gesturePassword;
    [self presentToMainController];
}

- (void)passwordGestureViewCheckPasswordWrong:(SSFPasswordGestureView *)passwordView
{
    self.alertLabel.text = @"手势密码错误,请重试";
}

@end
