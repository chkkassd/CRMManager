//
//  BusinessList.h
//  CRMManager
//
//  Created by peter on 14-8-25.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Business;

@interface BusinessList : NSManagedObject

@property (nonatomic, retain) NSString * lendingNo;
@property (nonatomic, retain) NSString * pattern;
@property (nonatomic, retain) NSString * incomeTotal;
@property (nonatomic, retain) NSString * investAmt;
@property (nonatomic, retain) NSString * contractNo;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * billDate;
@property (nonatomic, retain) NSString * loanValue;
@property (nonatomic, retain) NSString * managementFeeDiscount;
@property (nonatomic, retain) NSString * managementFeeRate;

@property (nonatomic, retain) Business *belongBusiness;

@end
