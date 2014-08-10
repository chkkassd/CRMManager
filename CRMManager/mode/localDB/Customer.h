//
//  Customer.h
//  CRMManager
//
//  Created by 施赛峰 on 14-8-9.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product;

@interface Customer : NSManagedObject

@property (nonatomic, retain) NSString * customerId;
@property (nonatomic, retain) NSString * customerName;
@property (nonatomic, retain) NSString * idNum;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * cdHope;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * customerType;
@property (nonatomic, retain) NSManagedObject *belongManager;
@property (nonatomic, retain) NSSet *allProducts;
@end

@interface Customer (CoreDataGeneratedAccessors)

- (void)addAllProductsObject:(Product *)value;
- (void)removeAllProductsObject:(Product *)value;
- (void)addAllProducts:(NSSet *)values;
- (void)removeAllProducts:(NSSet *)values;

@end