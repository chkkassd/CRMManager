//
//  ZDProductDetailViewController.m
//  CrmApp
//
//  Created by apple on 14-7-30.
//  Copyright (c) 2014年 com.zendai. All rights reserved.
//

#import "ZDProductDetailViewController.h"
#import "ZDExhibition.h"
#import "ZDExhibitionStore.h"

@interface ZDProductDetailViewController ()

@property (strong, nonatomic) ZDExhibition* product;

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *predictInterest;
@property (weak, nonatomic) IBOutlet UILabel *atLeastMoney;
@property (weak, nonatomic) IBOutlet UILabel *closePeriod;
@property (weak, nonatomic) IBOutlet UILabel *objectCustomer;

@end

@implementation ZDProductDetailViewController

- (void)setProductId:(NSString *)productId
{
    _productId = productId;
    
    self.product = [[ZDExhibitionStore sharedStore] productWithId:productId];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.productName.text = self.product.productName;
    self.predictInterest.text = self.product.predictInterest;
    self.atLeastMoney.text = self.product.atLeastMoney;
    self.closePeriod.text = self.product.closePeriod;
    self.objectCustomer.text = self.product.objectCustomer;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
