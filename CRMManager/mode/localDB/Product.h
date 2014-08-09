//
//  Product.h
//  CRMManager
//
//  Created by 施赛峰 on 14-8-9.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * productId;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSString * manageFee;
@property (nonatomic, retain) NSString * contractNumber;
@property (nonatomic, retain) NSManagedObject *belongCustomer;
@property (nonatomic, retain) NSManagedObject *theDetail;

@end
