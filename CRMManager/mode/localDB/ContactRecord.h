//
//  ContactRecord.h
//  CRMManager
//
//  Created by peter on 14-8-13.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Customer;

@interface ContactRecord : NSManagedObject

@property (nonatomic, retain) NSString * recordId;
@property (nonatomic, retain) NSString * contactType;
@property (nonatomic, retain) NSString * contactNum;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * hope;
@property (nonatomic, retain) NSString * contactTime;
@property (nonatomic, retain) NSString * managerId;
@property (nonatomic, retain) NSString * customerId;
@property (nonatomic, retain) NSString * inputId;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) Customer *recordBelongCustomer;

@end
