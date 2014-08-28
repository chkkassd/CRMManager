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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nameTextField.text = self.zdCustomer.customerName;
    self.mobileTextField.text = self.zdCustomer.mobile;
    [self.sexButton setTitle:[self.zdCustomer.sex isEqualToString:@"0"] ? @"女" : @"男" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
