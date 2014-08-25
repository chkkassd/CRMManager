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
#import "Product.h"
#import "ProductDetail.h"
#import "ZDManagerUser.h"
#import "ZDCustomer.h"
#import "ContactRecord.h"
#import "ZDContactRecord.h"
#import "Business.h"
#import "BusinessList.h"
#import "ZDBusiness.h"
#import "ZDBusinessList.h"

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
- (NSArray *)queryZDContactRecordsWithCustomerId:(NSString *)customerid;
- (NSArray *)queryAllZDBusinessListsWithCustomerId:(NSString *)customerid;
//modify and save
- (BOOL)loginSaveManagerUserWithZDManagerUser:(ZDManagerUser *)zdManager error:(NSError *__autoreleasing*)error;
- (BOOL)saveManagerUserWithZDManagerUser:(ZDManagerUser *)zdManager error:(NSError **)error;
- (BOOL)saveMuchCustomersWith:(NSArray *)customers error:(NSError **)error;
- (BOOL)saveCustomerWith:(ZDCustomer *)zdCustomer error:(NSError **)error;
- (BOOL)saveMuchContractRecordsWith:(NSArray *)contractRecords error:(NSError *__autoreleasing *)error;
- (BOOL)saveContactRecordWith:(ZDContactRecord *)zdContactRecord error:(NSError *__autoreleasing *)error;
- (BOOL)saveBusinessWith:(ZDBusiness *)zdBusiness error:(NSError *__autoreleasing *)error;
- (BOOL)saveBusinessList:(ZDBusinessList *)zdBusinessList error:(NSError *__autoreleasing *)error;
- (BOOL)saveMuchBusinessList:(NSArray *)zdBusinessLists error:(NSError *__autoreleasing *)error;
//delete
- (BOOL)deleteOneCustomerWithCustomerId:(NSString *)customerid error:(NSError **)error;
- (BOOL)deleteOneContactRecordWithReocrdId:(NSString *)recordid error:(NSError **)error;
//单例
+ (ZDLocalDB *)sharedLocalDB;

@end
