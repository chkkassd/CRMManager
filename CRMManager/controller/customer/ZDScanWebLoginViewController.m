//
//  ZDScanWebLoginViewController.m
//  CRMManager
//
//  Created by peter on 14-9-16.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDScanWebLoginViewController.h"

@interface ZDScanWebLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton * confirmButton;
@property (weak, nonatomic) IBOutlet UIButton * cancleButton;

@end

@implementation ZDScanWebLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma makr - properties

- (void)setConfirmButton:(UIButton *)confirmButton
{
    _confirmButton = confirmButton;
    _confirmButton.layer.cornerRadius = 5.0;
}

- (void)setCancleButton:(UIButton *)cancleButton
{
    _cancleButton = cancleButton;
    _cancleButton.layer.cornerRadius = 5.0;
}

#pragma makr - action

- (IBAction)confirmButtonPressed:(id)sender
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登陆CRM Web系统,请稍候";
    [[ZDModeClient sharedModeClient] scanToLoginOnWebConfirmByDimeCode:self.qrCode completionHandler:^(NSError *error) {
        if (!error) {
            hud.labelText = @"chenggong";
            [hud hide:YES];
        } else {
            hud.labelText = @"fail";
            [hud hide:YES];
        }
    }];
}

- (IBAction)cancleButtonPressed:(id)sender
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在取消登陆CRM Web系统,请稍候";
    [[ZDModeClient sharedModeClient] scanToLoginOnWebCancleByDimeCode:self.qrCode completionHandler:^(NSError *error) {
        if (!error) {
            hud.labelText = @"chenggong";
            [hud hide:YES];
        } else {
            hud.labelText = @"fail";
            [hud hide:YES];
        }
    }];
}

@end
