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

@interface ZDLoginViewController ()<ZDGesturePasswordViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView * nameView;
@property (weak, nonatomic) IBOutlet UIView * passwordView;
@property (weak, nonatomic) IBOutlet UIButton * loginButton;
@property (strong, nonatomic) ZDManagerUser *zdManagerUser;

@end

@implementation ZDLoginViewController

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultCurrentUserId];
//    NSString * defaultClientName = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultClientName];
//    NSString * defaultPassword = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultPassword];
    if (userid.length) {
        //非正常退出
        [self presentToGesturePasswordView];
        [[ZDModeClient sharedModeClient] quickLoginWithManagerUserId:userid];
    }
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
    _passwordView.layer.borderColor = [UIColor colorWithWhite:229/255.0 alpha:1.0].CGColor;
}

- (void)setLoginButton:(UIButton *)loginButton
{
    _loginButton = loginButton;
    _loginButton.layer.cornerRadius = 4.0;
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

- (void)presentToGesturePasswordView
{
    ZDGesturePasswordViewController * gesturePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ZDGesturePasswordViewController"];
    gesturePasswordViewController.delegate = self;
    [self presentViewController:gesturePasswordViewController animated:YES completion:NULL];
}

- (void)presentToMainView
{
    ZDTabBarViewController * tabBarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ZDTabBarViewController"];
    [self presentViewController:tabBarViewController animated:YES completion:NULL];
}

#pragma mark - ZDGesturePasswordViewControllerDelegate

- (void)gesturePasswordViewControllerDidFinish:(ZDGesturePasswordViewController *)controller
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        [self presentToMainView];
    }];
}

#pragma mark - properties

- (ZDManagerUser *)zdManagerUser
{
    if (!_zdManagerUser) {
        _zdManagerUser = [ZDModeClient sharedModeClient].zdManagerUser;
    }
    return _zdManagerUser;
}

- (IBAction)test:(id)sender
{
//    [[ZDWebService sharedWebViewService] fetchProductsWithCustomerId:@"1000248706" completionHandler:^(NSError *error, NSDictionary *resultDic) {
//        NSLog(@"resultDic = %@",resultDic);
//    }];
    
//    [[ZDWebService sharedWebViewService] fetchBusinessWithCustomerMobile:@"13322343432" andBusinessType:@"0" completionHandler:^(NSError *error, NSDictionary *resultDic) {
//        NSLog(@"resultDic = %@",resultDic);
//    }];
//    Customer * customer = [[ZDLocalDB sharedLocalDB] queryCustomerWithCustomerId:@"1000248706"];
//    NSLog(@"name = %@",customer.customerName);
//    [[ZDWebService sharedWebViewService] updatePotentialCustomer:@"chenjian" sex:@"1" managerId:@"507305" mobile:@"13564442916" memo:@"beizhu" hope:@"3" source:@"13" andCustomerId:@"1000541601" completionHandler:NULL];
//        [[ZDWebService sharedWebViewService] addPotentialCustomer:@"chenjian" sex:@"1" managerId:@"507305" mobile:@"13564442916" memo:@"beizhu" hope:@"3" source:@"13" completionHandler:NULL];
    
//    [[ZDWebService sharedWebViewService] deletePotentialCustomer:@"1000541601" completionHandler:NULL];
//    [[ZDWebService sharedWebViewService] updateContactRecord:@"507305" customerId:@"1000541602" contactType:@"1" contactNum:@"123" content:@"iloveyou" hope:@"3" contactTime:@"2012-07-12 12:12:12" inputDate:@"2012-07-12 12:12:12" inputId:@"987" memo:@"789" recordId:@"1000541850" handler:NULL];
    
//    [[ZDWebService sharedWebViewService] deleteContactRecord:@"1000541602" recordId:@"1000541850" completionHandler:NULL];
    
//    [[ZDWebService sharedWebViewService] fetchCustomersWithManagerUserId:@"507305" completionHandler:^(NSError *error, NSDictionary *resultDic) {
//        
//    }];
//    [[ZDWebService sharedWebViewService] fetchAllChanceCustomersWithManagerUserId:@"507305" completionHandler:^(NSError *error, NSDictionary *resultDic) {
//        
//    }];
//    [[ZDWebService sharedWebViewService] commitFeedbackWithManagerId:@"1026" Context:@"ahhahahahahahahaha" OperDate:@"2014-05-23 12:34:45" AppType:@"iphone" AppVersion:@"1.0" System:@"ios" SystemVersion:@"7.1" completionHandler:^(NSError *error, NSDictionary *resultDic) {
//        NSLog(@"hahahah");
//    }];
//    [[ZDWebService sharedWebViewService] fetchCustomerContactListWithManagerUserId:@"507305" andCustomerId:@"1000539807" completionHandler:^(NSError *error, NSDictionary *resultDic) {
//        
//    }];
    [[ZDWebService sharedWebViewService] fetchBusinessWithCustomerMobile:@"13339313631" andBusinessType:@"0" completionHandler:^(NSError *error, NSDictionary *resultDic) {
        
    }];
//{"status":"0"}
//    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://172.16.56.39:8765/hera/manageraccount/login"]];//alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://172.16.56.39:8765/hera/manageraccount/login"]];
//    NSString * str = @"{\"status\":\"0\"}";
//    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
//        NSError * error = nil;
//        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//    NSLog(@"%@",responseDic);
    
}
@end
