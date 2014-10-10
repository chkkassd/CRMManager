//
//  ZDCustomerDetailViewController.m
//  CRMManager
//
//  Created by apple on 14-8-26.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDCustomerDetailViewController.h"
#import "AllCustomerCategoryHeaders.h"

@interface ZDCustomerDetailViewController ()

@property (nonatomic, weak) IBOutlet UITextField* nameTextField;
@property (nonatomic, weak) IBOutlet UITextField* mobileTextField;
@property (nonatomic, weak) IBOutlet UIButton* sexButton;

@end

@implementation ZDCustomerDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.zdCustomer.customerName;
    self.nameTextField.text = self.zdCustomer.customerName;
    self.mobileTextField.text = [self stringForHiddenMobile:self.zdCustomer.mobile];
    [self.sexButton setTitle:[self.zdCustomer.sex isEqualToString:@"0"] ? @"女" : @"男" forState:UIControlStateNormal];
}

- (NSString *)stringForHiddenMobile:(NSString *)mobilestring
{
    if (!mobilestring.length) {
        return @"未设置";
    } else if (mobilestring.length < 8) return mobilestring;
    
    return [mobilestring stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
}

@end
