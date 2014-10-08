//
//  ZDScanResultViewController.h
//  CRMManager
//
//  Created by peter on 14-10-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZDScanResultViewControllerDelegate;
@interface ZDScanResultViewController : UIViewController

@property (strong, nonatomic) NSString * resultString;
@property (weak, nonatomic) id <ZDScanResultViewControllerDelegate> delegate;

@end

@protocol ZDScanResultViewControllerDelegate <NSObject>

- (void)scanResultViewControllerDidBack:(ZDScanResultViewController *)controller;

@end