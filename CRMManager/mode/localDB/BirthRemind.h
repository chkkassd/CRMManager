//
//  BirthRemind.h
//  CRMManager
//
//  Created by peter on 14-9-15.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Customer;

@interface BirthRemind : NSManagedObject

@property (nonatomic, retain) NSString * dataOfBirth;
@property (nonatomic, retain) Customer * birthOfCustomer;

@end
