//
//  BusinessList.h
//  CRMManager
//
//  Created by peter on 14-8-25.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Customer;

@interface BusinessList : NSManagedObject

@property (nonatomic, retain) NSString * customerName;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * feLendNo;
@property (nonatomic, retain) NSString * crmState;
@property (nonatomic, retain) NSString * fortuneState;
@property (nonatomic, retain) NSString * investAmt;
@property (nonatomic, retain) NSString * pattern;
@property (nonatomic, retain) Customer * businessListBelongToCustomer;
@end
