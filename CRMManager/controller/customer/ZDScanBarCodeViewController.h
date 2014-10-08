//
//  ZDScanBarCodeViewController.h
//  CRMManager
//
//  Created by peter on 14-9-5.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDModeClient.h"
#import "AllCustomerCategoryHeaders.h"

@protocol ZDScanBarCodeViewControllerDelegate;
@interface ZDScanBarCodeViewController : UIViewController

@property (weak, nonatomic) id <ZDScanBarCodeViewControllerDelegate> delegate;

@end

@protocol ZDScanBarCodeViewControllerDelegate <NSObject>

- (void)scanBarCodeViewControllerDidConfirmLoginOnWeb:(ZDScanBarCodeViewController *)controller;
- (void)scanBarCodeViewControllerDidCancleLoginOnWeb:(ZDScanBarCodeViewController *)controller;
- (void)scanBarCodeViewControllerDidBack:(ZDScanBarCodeViewController *)controller;

@end