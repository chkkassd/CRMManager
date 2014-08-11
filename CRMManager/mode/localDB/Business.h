//
//  Business.h
//  CRMManager
//
//  Created by peter on 14-8-11.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Business : NSManagedObject

@property (nonatomic, retain) NSString * incomeTotal;
@property (nonatomic, retain) NSString * customerName;
@property (nonatomic, retain) NSString * applyDate;
@property (nonatomic, retain) NSString * productType;
@property (nonatomic, retain) NSString * accountTotal;
@property (nonatomic, retain) NSString * recoverableAmount;

@end
