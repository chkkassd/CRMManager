//
//  ZDSuggestionViewController.m
//  CRMManager
//
//  Created by peter on 14-8-15.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDSuggestionViewController.h"

@interface ZDSuggestionViewController ()

@property (weak, nonatomic) IBOutlet UITextView * textView;
@property (weak, nonatomic) IBOutlet UILabel * placeholderLabel;

@end

@implementation ZDSuggestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Action 

- (IBAction)commitButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    if (!self.textView.text.length) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"请输入意见" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        return;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在提交,请稍后";
    [[ZDModeClient sharedModeClient] commitFeedbackWithContext:self.textView.text completionHandler:^(NSError *error) {
        if (!error) {
            hud.labelText = @"提交成功";
            [hud hide:YES afterDelay:1];
        } else {
            hud.labelText = @"提交失败,请稍后再试";
            [hud hide:YES afterDelay:1];
        }
    }];
}

#pragma mark - properties

- (void)setTextView:(UITextView *)textView
{
    _textView = textView;
    [_textView becomeFirstResponder];
}

#pragma mark - textview delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

@end
