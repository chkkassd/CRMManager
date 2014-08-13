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
@property (strong, nonatomic) ZDManagerUser *zdManagerUser;

@end

@implementation ZDLoginViewController

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameTextField.text = @"crm";
    self.passwordTextField.text = @"wozhengdebuzhidao";
}

#pragma mark - Action

- (IBAction)loginButtonPressed:(id)sender
{
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
            NSLog(@"fail to login");
        }
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
    
//    [[ZDWebService sharedWebViewService] fetchBusinessWithCustomerMobile:@"18616689317" andBusinessType:@"0" completionHandler:^(NSError *error, NSDictionary *resultDic) {
//        NSLog(@"resultDic = %@",resultDic);
//    }];
//    Customer * customer = [[ZDLocalDB sharedLocalDB] queryCustomerWithCustomerId:@"1000248706"];
//    NSLog(@"name = %@",customer.customerName);
//    [[ZDWebService sharedWebViewService] updatePotentialCustomer:@"chenjian" sex:@"1" managerId:@"507305" mobile:@"13564442916" memo:@"beizhu" hope:@"3" source:@"13" andCustomerId:@"1000541601" completionHandler:NULL];
//        [[ZDWebService sharedWebViewService] addPotentialCustomer:@"chenjian" sex:@"1" managerId:@"507305" mobile:@"13564442916" memo:@"beizhu" hope:@"3" source:@"13" completionHandler:NULL];
    
//    [[ZDWebService sharedWebViewService] deletePotentialCustomer:@"1000541601" completionHandler:NULL];
//    [[ZDWebService sharedWebViewService] updateContactRecord:@"507305" customerId:@"1000541602" contactType:@"1" contactNum:@"123" content:@"iloveyou" hope:@"3" contactTime:@"2012-07-12 12:12:12" inputDate:@"2012-07-12 12:12:12" inputId:@"987" memo:@"789" recordId:@"1000541850" handler:NULL];
    
//    [[ZDWebService sharedWebViewService] deleteContactRecord:@"1000541602" recordId:@"1000541850" completionHandler:NULL];
    
    [[ZDWebService sharedWebViewService] fetchCustomersWithManagerUserId:@"1026" completionHandler:^(NSError *error, NSDictionary *resultDic) {
        
    }];
    
}
@end
