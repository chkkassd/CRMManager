//
//  ZDProductViewController.m
//  CrmApp
//
//  Created by apple on 14-7-30.
//  Copyright (c) 2014年 com.zendai. All rights reserved.
//

#import "ZDProductsListViewController.h"
#import "ZDProductCell.h"
#import "ZDExhibitionStore.h"
#import "ZDExhibition.h"

@interface ZDProductsListViewController ()

@property (strong, nonatomic) NSArray *products;

@end

@implementation ZDProductsListViewController

- (NSArray *)products
{
    if (!_products) {
        _products = [ZDExhibitionStore sharedStore].products;
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
    
    ZDExhibition* product = self.products[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:product.iconName];
    cell.label.text = product.productName;
    return cell;
}



@end
