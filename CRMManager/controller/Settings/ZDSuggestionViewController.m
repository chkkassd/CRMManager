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
