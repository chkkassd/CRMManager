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
}

#pragma mark - Action

- (IBAction)finishButtonPressed:(id)sender
{
    
}

#pragma text view delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

@end
