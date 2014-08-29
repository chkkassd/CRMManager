//
//  ZDSuggestionViewController.h
//  CRMManager
//
//  Created by peter on 14-8-15.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDModeClient.h"
#import "AllCustomerCategoryHeaders.h"

@protocol ZDSuggestionViewControllerDelegate;
@interface ZDSuggestionViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) id <ZDSuggestionViewControllerDelegate> delegate;

@end

@protocol ZDSuggestionViewControllerDelegate <NSObject>

- (void)suggestionViewControllerDidFinishFeedBack:(ZDSuggestionViewController *)controller;

@end