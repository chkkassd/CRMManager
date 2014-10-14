//
//  ZDLoginViewController.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDLoginViewController.h"
#import "ZDModeClient.h"
#import "ZDGesturePasswordViewController.h"
#import "ZDTabBarViewController.h"

@interface ZDLoginViewController ()<ZDGesturePasswordViewControllerDelegate,ZDTabBarViewControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView * nameView;
@property (weak, nonatomic) IBOutlet UIView * passwordView;
@property (weak, nonatomic) IBOutlet UIButton * loginButton;
@property (strong, nonatomic) ZDManagerUser *zdManagerUser;
@property (nonatomic) BOOL isMoveUp;//只在ipohone4上用到

@property (nonatomic) BOOL isQuickLogin;

@end

@implementation ZDLoginViewController

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateManagerUser:) name:ZDUpdateManagerUserNotification object:[ZDModeClient sharedModeClient]];
    
    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultCurrentUserId];
    if (userid.length) {
        //非正常退出
        self.isQuickLogin = YES;
    } else self.isQuickLogin = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultCurrentUserId];
    
    if (self.isQuickLogin) {
        [self presentToGesturePasswordView];
        [[ZDModeClient sharedModeClient] quickLoginWithManagerUserId:userid];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - properties

- (void)setNameView:(UIView *)nameView
{
    _nameView = nameView;
    _nameView.layer.borderColor = [UIColor colorWithWhite:229/255.0 alpha:1.0].CGColor;
}

- (void)setPasswordView:(UIView *)passwordView
{
    _passwordView = passwordView;
    _passwordView.layer.borderColor = [UIColor colorWithWhite:218/255.0 alpha:1.0].CGColor;
}

- (void)setLoginButton:(UIButton *)loginButton
{
    _loginButton = loginButton;
    _loginButton.layer.cornerRadius = 4.0;
}

- (ZDManagerUser *)zdManagerUser
{
    if (!_zdManagerUser) {
        _zdManagerUser = [ZDModeClient sharedModeClient].zdManagerUser;
    }
    return _zdManagerUser;
}

#pragma mark - Action

- (IBAction)loginButtonPressed:(id)sender
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在登陆,请稍后..";
    [[ZDModeClient sharedModeClient] loginWithUserName:self.nameTextField.text password:self.passwordTextField.text completionHandler:^(NSError *error) {
        if (!error) {
            if (!self.zdManagerUser.gesturePassword.length) {
                //第一次登陆，设置手势密码
                [self presentToGesturePasswordView];
            } else {
                //已设置过手势密码
                [self presentToMainView];
            }
        } else {
            hud.labelText = @"登陆失败,请稍后再试";
            NSLog(@"fail to login");
        }
        [hud hide:YES afterDelay:1];
    }];

}

- (IBAction)hideKeyboard:(id)sender
{
    [self.view endEditing:YES];
    
    if ([self checkIphoneType] == checkResultIphone4) {
        if (self.isMoveUp) {
            [UIView animateWithDuration:0.5 animations:^{
                self.nameView.frame = CGRectMake(self.nameView.frame.origin.x, self.nameView.frame.origin.y + DefaultMoveUpDistance, self.nameView.frame.size.width, self.nameView.frame.size.height);
                self.passwordView.frame = CGRectMake(self.passwordView.frame.origin.x, self.passwordView.frame.origin.y +DefaultMoveUpDistance, self.passwordView.frame.size.width, self.passwordView.frame.size.height);
            } completion:^(BOOL finished) {
                self.isMoveUp = NO;
            }];
        }
    }
}

#pragma mark - methods

- (void)updateManagerUser:(NSNotification *)noti
{
    self.zdManagerUser = [ZDModeClient sharedModeClient].zdManagerUser;
}

- (void)presentToGesturePasswordView
{
    ZDGesturePasswordViewController * gesturePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ZDGesturePasswordViewController"];
    gesturePasswordViewController.delegate = self;
    [self presentViewController:gesturePasswordViewController animated:YES completion:NULL];
}

- (void)presentToMainView
{
    ZDTabBarViewController * tabBarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ZDTabBarViewController"];
    tabBarViewController.customDelegate = self;
    [self presentViewController:tabBarViewController animated:YES completion:NULL];
}

- (IphoneType)checkIphoneType
{
    if (self.view.frame.size.height >= 736) {
        return checkResultIphone6p;
    } else if (self.view.frame.size.height >= 667) {
        return checkResultIphone6;
    } else if (self.view.frame.size.height >= 568) {
        return checkResultIphone5;
    } else {
        return checkResultIphone4;
    }
}

#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self checkIphoneType] == checkResultIphone4) {
        if (!self.isMoveUp) {
            [UIView animateWithDuration:0.5 animations:^{
                self.nameView.frame = CGRectMake(self.nameView.frame.origin.x, self.nameView.frame.origin.y - DefaultMoveUpDistance, self.nameView.frame.size.width, self.nameView.frame.size.height);
                self.passwordView.frame = CGRectMake(self.passwordView.frame.origin.x, self.passwordView.frame.origin.y - DefaultMoveUpDistance, self.passwordView.frame.size.width, self.passwordView.frame.size.height);
            } completion:^(BOOL finished) {
                self.isMoveUp = YES;
            }];
        }
    }
}

#pragma mark - ZDGesturePasswordViewControllerDelegate

- (void)gesturePasswordViewControllerDidFinish:(ZDGesturePasswordViewController *)controller
{
    self.isQuickLogin = NO;
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        [self presentToMainView];
    }];
}

- (void)gesturePasswordViewControllerDidForgetGesturePassword:(ZDGesturePasswordViewController *)controller
{
    self.isQuickLogin = NO;
    NSString * defaultClientName = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultClientName];
    self.nameTextField.text = defaultClientName;
    self.passwordTextField.text = @"";
    [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - tabbar view delegate

- (void)tabBarViewControllerDidLogOut:(ZDTabBarViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSString * defaultClientName = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultClientName];
        NSString * defaultPassword = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultPassword];
        self.nameTextField.text = defaultClientName;
        self.passwordTextField.text = defaultPassword;
    }];
}

- (void)tabBarViewControllerDidForgetGesturePasswordAndRelogin:(ZDTabBarViewController *)controller
{
    NSString * defaultClientName = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultClientName];
    self.nameTextField.text = defaultClientName;
    self.passwordTextField.text = @"";
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
