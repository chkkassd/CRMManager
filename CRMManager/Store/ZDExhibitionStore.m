//
//  ZDProductStore.m
//  CRMManager
//
//  Created by joseph on 9/5/14.
//  Copyright (c) 2014 peter. All rights reserved.
//

#import "ZDExhibitionStore.h"
#import "ZDExhibition.h"

@interface ZDExhibitionStore ()


@end

@implementation ZDExhibitionStore


- (NSArray *)products
{
    NSMutableArray* m_products;
    if (!_products) {
        //
        m_products = [NSMutableArray new];
        
        // 1. get plist path
        NSString* path = [[NSBundle mainBundle] pathForResource:@"product.plist" ofType:nil];

        // 2. load array
        _products = [NSArray arrayWithContentsOfFile:path];
        
        NSLog(@"%@", _products);
        
        
        for (NSDictionary* dic in _products) {
            ZDExhibition* product = [ZDExhibition new];
            product.iconName = dic[@"icon"];
            product.productName = dic[@"name"];
            [m_products addObject:product];
        }
    }
    return [m_products copy];
}


+ (instancetype)sharedStore
{
    static ZDExhibitionStore* sharedStore;
    if (!sharedStore) {
        sharedStore = [ZDExhibitionStore new];
    }
    return sharedStore;
}

@end
