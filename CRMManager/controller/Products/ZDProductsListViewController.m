//
//  ZDProductViewController.m
//  CrmApp
//
//  Created by apple on 14-7-30.
//  Copyright (c) 2014年 com.zendai. All rights reserved.
//

#import "ZDProductsListViewController.h"
#import "ZDProductCell.h"

@interface ZDProductsListViewController ()

@property (strong, nonatomic) NSArray *products;


@end

@implementation ZDProductsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (NSArray *)products
{
    if (!_products) {
        _products = @[@{@"imageName":@"ico_product_01", @"productName": @"证大岁悦"},
                      @{@"imageName":@"ico_product_02", @"productName": @"证大季喜"},
                      @{@"imageName":@"ico_product_03", @"productName": @"证大年丰"},
                      @{@"imageName":@"ico_product_04", @"productName": @"证大月收"},
                      @{@"imageName":@"ico_product_05", @"productName": @"证大双鑫"},
                      ];
    }
    return _products;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZDProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Product Cell" forIndexPath:indexPath];
    
    NSDictionary* product = self.products[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:product[@"imageName"]];
    cell.label.text = product[@"productName"];
    return cell;
}



@end
