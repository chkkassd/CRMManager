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
#import "ZDProductDetailViewController.h"

@interface ZDProductsListViewController ()

@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) ZDExhibition* selectedProduct;

@end

@implementation ZDProductsListViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Product Detail"]) {
        ZDProductDetailViewController* detailVc = (ZDProductDetailViewController *)segue.destinationViewController;
        detailVc.productId = self.selectedProduct.productId;
    }
}

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

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedProduct = self.products[indexPath.row];

    [self performSegueWithIdentifier:@"Show Product Detail" sender:self];
}

@end
