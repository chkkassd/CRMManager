//
//  ManagerUser.h
//  CRMManager
//
//  Created by 施赛峰 on 14-8-9.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Customer;

@interface ManagerUser : NSManagedObject

@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * gesturePassword;
@property (nonatomic, retain) NSString * customersCount;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * director;
@property (nonatomic, retain) NSSet *allCustomers;
@end

@interface ManagerUser (CoreDataGeneratedAccessors)

- (void)addAllCustomersObject:(Customer *)value;
- (void)removeAllCustomersObject:(Customer *)value;
- (void)addAllCustomers:(NSSet *)values;
- (void)removeAllCustomers:(NSSet *)values;

@end
