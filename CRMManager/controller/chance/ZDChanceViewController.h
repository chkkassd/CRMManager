//
//  ZDChanceViewController.h
//  CRMManager
//
//  Created by peter on 14-8-18.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDModeClient.h"
#import "AllCustomerCategoryHeaders.h"

@interface ZDChanceViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,
                                                    UISearchBarDelegate,UISearchDisplayDelegate,
                                                    UIActionSheetDelegate,UIScrollViewAccessibilityDelegate>
- (void)checkNetAndShow:(BOOL)havenet;
@end
