//
//  ZDRecordAddOrEditViewController.m
//  CRMManager
//
//  Created by peter on 14-8-19.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDRecordAddOrEditViewController.h"

@interface ZDRecordAddOrEditViewController ()

@property (weak, nonatomic) IBOutlet UILabel * placeholderLabel;
@property (weak, nonatomic) IBOutlet UITextView * textView;

@end

@implementation ZDRecordAddOrEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)configureView
{
    if (self.editedReocrd) {
        self.title = @"编辑记录";
        self.textView.text = self.editedReocrd.content;
    } else {
        self.title = @"新增记录";
    }
    [self shouldHideLabel];
}

#pragma mark - properties

- (void)setTextView:(UITextView *)textView
{
    _textView = textView;
    [_textView becomeFirstResponder];
}

#pragma mark - Action

- (IBAction)finishButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    NSDictionary * infoDic = @{
                           @"managerId": [ZDModeClient sharedModeClient].zdManagerUser.userid,
                           @"customerId": self.selectedCustomer.customerId,
                           @"contactType": @"1",//contactType: 联系方式（1-电话、2-邮件、3-QQ、4-传真）
                           @"contactNum": self.selectedCustomer.mobile,
                           @"memo": @"",
                           @"hope": self.selectedCustomer.cdHope.length? self.selectedCustomer.cdHope :@"3",//意愿若不存在，默认为3
                           @"content": self.textView.text,
                           @"contactTime": [NSString stringTranslatedFromDate:[NSDate date]],
                           @"inputDate": [NSString stringTranslatedFromDate:[NSDate date]],
                           @"inputId": [ZDModeClient sharedModeClient].zdManagerUser.userid,
                           
                           };
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (self.editedReocrd) {
        //编辑记录
        [[ZDModeClient sharedModeClient] updateContactRecordWithInfoDictionary:infoDic recordId:self.editedReocrd.recordId completionHandler:^(NSError *error) {
            if (!error) {
                [hud hide:YES];
                [self.delegate recordAddOrEditViewControllerDidfinishEditRecord:self];
            } else {
                hud.labelText = @"修改联系记录失败,请稍后尝试";
                [hud hide:YES afterDelay:1];
            }
        }];
    } else {
        //新增记录
        [[ZDModeClient sharedModeClient] addContactRecordWithInfoDictionary:infoDic completionHandler:^(NSError *error) {
            if (!error) {
                [hud hide:YES];
                [self.delegate recordAddOrEditViewControllerDidFinishAddRecord:self];
            } else {
                hud.labelText = @"添加联系记录失败,请稍后尝试";
                [hud hide:YES afterDelay:1];
            }
        }];
    }
}

#pragma text view delegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self shouldHideLabel];
}

- (void)shouldHideLabel
{
    self.placeholderLabel.hidden = self.textView.text.length > 0;
}

@end
