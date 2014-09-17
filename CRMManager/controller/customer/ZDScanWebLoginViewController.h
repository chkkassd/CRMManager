//
//  ZDScanWebLoginViewController.h
//  CRMManager
//
//  Created by peter on 14-9-16.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDModeClient.h"
#import "AllCustomerCategoryHeaders.h"

@protocol ZDScanWebLoginViewControllerDelegate;
@interface ZDScanWebLoginViewController : UIViewController

@property (strong, nonatomic) NSString * qrCode;
@property (weak, nonatomic) id <ZDScanWebLoginViewControllerDelegate> delegate;

@end

@protocol ZDScanWebLoginViewControllerDelegate <NSObject>

- (void)scanWebLoginViewControllerDidConfirmLogin:(ZDScanWebLoginViewController *)controller;
- (void)scanWebLoginViewControllerDidCancleLogin:(ZDScanWebLoginViewController *)controller;

@end