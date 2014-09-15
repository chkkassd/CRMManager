//
//  InvestmentRemind.h
//  CRMManager
//
//  Created by peter on 14-9-15.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Customer;

@interface InvestmentRemind : NSManagedObject

@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * investAmt;
@property (nonatomic, retain) NSString * pattern;
@property (nonatomic, retain) Customer *investmentRemindOfCustomer;

@end
