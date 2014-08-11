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

@interface ZDLocalDB : NSObject

//query
- (ZDManagerUser *)queryCurrentZDmanagerUser;
- (ManagerUser *)queryManagerUserWithUserId:(NSString *)userid;
- (Customer *)queryCustomerWithCustomerId:(NSString *)customerid;
//modify and save
- (BOOL)loginSaveManagerUserWithZDManagerUser:(ZDManagerUser *)zdManager error:(NSError *__autoreleasing*)error;
- (BOOL)saveManagerUserWithZDManagerUser:(ZDManagerUser *)zdManager error:(NSError **)error;
- (BOOL)saveMuchCustomersWith:(NSArray *)customers error:(NSError **)error;
- (BOOL)saveCustomerWith:(ZDCustomer *)zdCustomer error:(NSError **)error;
//单例
+ (ZDLocalDB *)sharedLocalDB;

@end
