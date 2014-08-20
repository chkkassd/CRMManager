//
//  ZDAddAndEditeViewController.m
//  CRMManager
//
//  Created by peter on 14-8-19.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDAddAndEditeViewController.h"
#import "AllCustomerCategoryHeaders.h"

@interface ZDAddAndEditeViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView * scrollView;
@property (weak, nonatomic) IBOutlet UITextField * mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField * nameTextField;
@property (weak, nonatomic) IBOutlet UIButton * sexButton;
@property (weak, nonatomic) IBOutlet UIButton * hopeButton;
@property (weak, nonatomic) IBOutlet UITextView * textView;
@property (nonatomic) NSInteger sexNum;
@property (nonatomic) NSInteger hopeNum;

@end

@implementation ZDAddAndEditeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)configureView
{
    if (self.mode == ZDAddAndEditeViewControllerModeEdit && self.editedCustomer) {
        self.title = self.editedCustomer.customerName;
        self.mobileTextField.text = self.editedCustomer.mobile;
        self.nameTextField.text = self.editedCustomer.customerName;
        [self.sexButton setTitle:@"男" forState:UIControlStateNormal];
        [self.hopeButton setTitle:self.editedCustomer.cdHope forState:UIControlStateNormal];
    } else {
        self.title = @"新增客户";
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 200);
//    NSLog(@"%f,%f",self.scrollView.contentSize.width,self.scrollView.contentSize.height);
}

#pragma mark - properties

- (NSInteger)sexNum
{
    if (!_sexNum) {
        _sexNum = 1;//默认男
    }
    return _sexNum;
}

- (NSInteger)hopeNum
{
    if (!_hopeNum) {
        _hopeNum = 3;//默认一般
    }
    return _hopeNum;
}

#pragma mark - Action

- (IBAction)finishButtonPressed:(id)sender
{
    if (!self.nameTextField.text.length || !self.mobileTextField.text.length) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"手机或姓名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    NSDictionary * infoDictionary = @{
                                      @"customerName": self.nameTextField.text,
                                      @"sex": [NSString stringWithFormat:@"%d",self.sexNum],
                                      @"managerId": [ZDModeClient sharedModeClient].zdManagerUser.userid,
                                      @"mobile": self.mobileTextField.text,
                                      @"memo": self.textView.text,
                                      @"hope": [NSString stringWithFormat:@"%d",self.hopeNum],
                                      @"source": @"ios"
                                      };
    
    if (self.mode == ZDAddAndEditeViewControllerModeEdit && self.editedCustomer) {
        //编辑机会客户
        [[ZDModeClient sharedModeClient] updateChanceCustomerWithCustomerInfoDictionary:infoDictionary customerId:self.editedCustomer.customerId completionHandler:^(NSError *error) {
            if (!error) {
                hud.labelText = @"修改成功";
                [hud hide:YES afterDelay:1];
            } else {
                hud.labelText = @"修改失败";
                [hud hide:YES afterDelay:1];
            }
        }];
    } else {
        //添加机会客户
        [[ZDModeClient sharedModeClient] addChanceCustomerWithCustomerInfoDictionary:infoDictionary completionHandler:^(NSError *error) {
            if (!error) {
                hud.labelText = @"添加成功";
                [hud hide:YES afterDelay:1];
            } else {
                hud.labelText = @"添加失败";
                [hud hide:YES afterDelay:1];
            }
        }];
    }
}

- (IBAction)sexButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    [sheet showInView:self.view];
}

- (IBAction)hopeButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"意愿" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"一般",@"感兴趣",@"强烈", nil];
    [sheet showInView:self.view];
}

- (IBAction)hideKeyBoard:(id)sender
{
    [self.view endEditing:YES];
}
#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([actionSheet.title isEqualToString:@"性别"]) {
        if ([buttonTitle isEqualToString:@"男"]) {
            self.sexNum = 1;
            [self.sexButton setTitle:@"男" forState:UIControlStateNormal];
        } else {
            self.sexNum = 0;
            [self.sexButton setTitle:@"女" forState:UIControlStateNormal];
        }
        
    } else if ([actionSheet.title isEqualToString:@"意愿"]) {
        if ([buttonTitle isEqualToString:@"一般"]) {
            self.hopeNum = 3;
            [self.hopeButton setTitle:@"一般" forState:UIControlStateNormal];
        } else if ([buttonTitle isEqualToString:@"感兴趣"]) {
            self.hopeNum = 2;
            [self.hopeButton setTitle:@"感兴趣" forState:UIControlStateNormal];
        } else {
            self.hopeNum = 1;
            [self.hopeButton setTitle:@"强烈" forState:UIControlStateNormal];
        }
    }
}

@end