//
//  ZDLocalDB.h
//  CRMManager
//
//  Created by 施赛峰 on 14-8-9.
//  Copyright (c) 2014年 peter. All rights reserved.

//管理本地数据库类

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ZDModeClient.h"
#import "ManagerUser.h"
#import "Customer.h"
#import "ZDManagerUser.h"
#import "ZDCustomer.h"
#import "ContactRecord.h"
#import "ZDContactRecord.h"
#import "BusinessList.h"
#import "ZDBusinessList.h"
#import "BirthRemind.h"
#import "InvestmentRemind.h"
#import "ZDInvestmentRemind.h"

@interface ZDLocalDB : NSObject

//query
- (ZDManagerUser *)queryCurrentZDmanagerUser;
- (ManagerUser *)queryManagerUserWithUserId:(NSString *)userid;
- (ContactRecord *)queryContactRecordWithRecordId:(NSString *)recordId;
- (ZDContactRecord *)queryZDContactRecordWithRecordId:(NSString *)recordId;
- (Customer *)queryCustomerWithCustomerId:(NSString *)customerid;
- (ZDCustomer *)queryZDCustomerWithCustomerId:(NSString *)customerid;
- (NSArray *)queryAllZDCustomersOfCurrentManager;
- (NSArray *)queryAllZDChanceCustomersOfCurrentManager;
- (NSArray *)queryAllZDCurrentCustomersOfCurrentManager;
- (NSArray *)queryZDContactRecordsWithCustomerId:(NSString *)customerid;
- (NSArray *)queryAllZDBusinessListsWithCustomerId:(NSString *)customerid;
- (BirthRemind *)queryBirthRemindByRelationshipWithCustomerId:(NSString *)customerId;
- (NSArray *)queryAllZDInvestmentRemindsWithCustomerId:(NSString *)customerid;
- (ZDInvestmentRemind *)queryZDInvestmentRemindWithCustomerId:(NSString *)customerid
                                                  andFeLendNo:(NSString *)felendNo;
//modify and save
- (BOOL)loginSaveManagerUserWithZDManagerUser:(ZDManagerUser *)zdManager error:(NSError *__autoreleasing*)error;
- (BOOL)saveManagerUserWithZDManagerUser:(ZDManagerUser *)zdManager error:(NSError **)error;
- (BOOL)saveMuchCustomersWith:(NSArray *)customers error:(NSError **)error;
- (BOOL)saveCustomerWith:(ZDCustomer *)zdCustomer error:(NSError **)error;
- (BOOL)saveMuchContractRecordsWith:(NSArray *)contractRecords error:(NSError *__autoreleasing *)error;
- (BOOL)saveContactRecordWith:(ZDContactRecord *)zdContactRecord error:(NSError *__autoreleasing *)error;
- (BOOL)saveBusinessList:(ZDBusinessList *)zdBusinessList error:(NSError *__autoreleasing *)error;
- (BOOL)saveMuchBusinessList:(NSArray *)zdBusinessLists error:(NSError *__autoreleasing *)error;
- (BOOL)saveBirthReminds:(NSArray *)zdBirthReminds error:(NSError *__autoreleasing *)error;
- (BOOL)saveInvestmentReminds:(NSArray *)zdInvestmentReminds error:(NSError *__autoreleasing *)error;
//delete
- (BOOL)deleteOneCustomerWithCustomerId:(NSString *)customerid error:(NSError **)error;
- (BOOL)deleteOneContactRecordWithReocrdId:(NSString *)recordid error:(NSError **)error;
- (BOOL)deleteManagerUserWithUserId:(NSString *)userid error:(NSError **)error;
- (BOOL)deleteOneInvestmentRemindWithCustomerId:(NSString *)customerid
                                       feLendNo:(NSString *)feLendNo
                                          error:(NSError *__autoreleasing *)error;
//- (BOOL)deleteOneBirthRemindWithCustomerId:(NSString *)customerid
//                                     error:(NSError *__autoreleasing *)error;
//单例
+ (ZDLocalDB *)sharedLocalDB;

@end
