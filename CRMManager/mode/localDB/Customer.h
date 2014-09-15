//
//  Customer.h
//  CRMManager
//
//  Created by 施赛峰 on 14-8-9.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BirthRemind;
@class InvestmentRemind;
@class Business;

@interface Customer : NSManagedObject

@property (nonatomic, retain) NSString * customerId;
@property (nonatomic, retain) NSString * customerName;
@property (nonatomic, retain) NSString * idNum;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * cdHope;
@property (nonatomic, retain) NSString * customerType;//1-储备客户、2-客户、3-老客户
@property (nonatomic, retain) NSString * sex;//1-男、0-女
@property (nonatomic, retain) NSString * memo;//备注

@property (nonatomic, retain) NSManagedObject * belongManager;
@property (nonatomic, retain) NSSet * allContactRecords;
@property (nonatomic, retain) Business * business;
@property (nonatomic, retain) BirthRemind * birthRemind;
@property (nonatomic, retain) NSSet * allInvestmentReminds;

@end

@interface Customer (CoreDataGeneratedAccessors)

//- (void)addAllProductsObject:(Product *)value;
//- (void)removeAllProductsObject:(Product *)value;
//- (void)addAllProducts:(NSSet *)values;
//- (void)removeAllProducts:(NSSet *)values;

@end
