//
//  ZDLoginViewController.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDLoginViewController.h"
#import "ZDModeClient.h"

@interface ZDLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

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
            NSLog(@"success to login");
        } else {
            NSLog(@"fail to login");
        }
    }];
}

- (IBAction)test:(id)sender
{
    [[ZDWebService sharedWebViewService] fetchProductsWithCustomerId:@"1000248706" completionHandler:^(NSError *error, NSDictionary *resultDic) {
        NSLog(@"resultDic = %@",resultDic);
    }];
     
}
@end
