//
//  ZDScanResultViewController.m
//  CRMManager
//
//  Created by peter on 14-10-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDScanResultViewController.h"

@interface ZDScanResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel * resultLabel;

@end

@implementation ZDScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.resultString.length) {
        self.resultLabel.text = self.resultString;
    }
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.delegate scanResultViewControllerDidBack:self];
}

@end
