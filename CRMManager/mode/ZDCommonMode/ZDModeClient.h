//
//  ZDModeClient.h
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.

//所有底层接口均通过此类对外开放

#import <Foundation/Foundation.h>
#import "ZDWebService.h"
#import "ZDLocalDB.h"
#import "ZDCachePathUtility.h"
#import "ZDManagerUser.h"
#import "ZDCustomer.h"
#import "ZDProduct.h"
#import "ZDProductDetail.h"

#define DefaultCurrentUserId    @"DefaultCurrentUserId"
#define ZDUpdateManagerUserNotification  @"UpdateManagerUserNotification"
#define ZDUpdateCustomersNotification  @"UpdateCustomersNotification"
#define ZDUpdateContactRecordsNotification  @"UpdateContactRecordsNotification"

@interface ZDModeClient : NSObject

//login
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSError *error))handler;

//common propertise
@property (strong, nonatomic) ZDManagerUser *zdManagerUser;//当前使用用户
@property (strong, nonatomic) NSArray * allZDCustomers;//当前manager的所有customers
@property (strong, nonatomic) NSArray * allZDChanceCustomers;//当前manager的所有chanceCustomers

//保存manageruser
- (BOOL)saveZDManagerUser:(ZDManagerUser *)zdManageruser;
//得到一个客户的所有联系记录
- (NSArray *)zdContactRecordsWithCustomerId:(NSString *)customerid;
//新增机会客户
- (void)addChanceCustomerWithCustomerInfoDictionary:(NSDictionary *)infoDictionary
                                  completionHandler:(void(^)(NSError * error))handler;
//更新储备客户
- (void)updateChanceCustomerWithCustomerInfoDictionary:(NSDictionary *)infoDictionary
                                            customerId:(NSString *)customerid
                                     completionHandler:(void(^)(NSError * error))handler;

//单例
+ (ZDModeClient *)sharedModeClient;

@end
