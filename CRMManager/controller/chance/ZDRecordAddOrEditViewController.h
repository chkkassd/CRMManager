//
//  ZDRecordAddOrEditViewController.h
//  CRMManager
//
//  Created by peter on 14-8-19.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDModeClient.h"

@interface ZDRecordAddOrEditViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) ZDContactRecord * editedReocrd;

@end
