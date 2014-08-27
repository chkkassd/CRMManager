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
#import "AllCustomerCategoryHeaders.h"
#import "ZDBusiness.h"
#import "ZDBusinessList.h"

#define DefaultCurrentUserId    @"DefaultCurrentUserId"
#define DefaultClientName   @"DefaultClientName"
#define DefaultPassword     @"DefaultPassword"
#define ZDUpdateManagerUserNotification  @"UpdateManagerUserNotification"
#define ZDUpdateCustomersNotification  @"UpdateCustomersNotification"
#define ZDUpdateContactRecordsNotification  @"UpdateContactRecordsNotification"
#define ZDUpdateBusinessAndBusinessListsNotification  @"UpdateBusinessAndBusinessListsNotification"

@interface ZDModeClient : NSObject

//快速登陆
- (void)quickLoginWithManagerUserId:(NSString *)userid;
//login
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSError *error))handler;

//common propertise
@property (strong, nonatomic) ZDManagerUser *zdManagerUser;//当前使用用户
@property (strong, nonatomic) NSArray * allZDCustomers;//当前manager的所有customers
@property (strong, nonatomic) NSArray * allZDChanceCustomers;//当前manager的所有chanceCustomers
@property (strong, nonatomic) NSArray * allZDCurrentCustomers;// 当前manager的所有非储备客户，正在做业务的客户或者老客户

//查找得到一个zdcustomer
- (ZDCustomer *)zdCustomerWithCustomerId:(NSString *)customerid;
//得到一个客户的所有联系记录
- (NSArray *)zdContactRecordsWithCustomerId:(NSString *)customerid;
//得到一个客户所有的businessList产品
- (NSArray *)zdBusinessListsWithCustomerId:(NSString *)customerid;

//保存manageruser
- (BOOL)saveZDManagerUser:(ZDManagerUser *)zdManageruser;
//新增机会客户
- (void)addChanceCustomerWithCustomerInfoDictionary:(NSDictionary *)infoDictionary
                                  completionHandler:(void(^)(NSError * error))handler;
//更新储备客户
- (void)updateChanceCustomerWithCustomerInfoDictionary:(NSDictionary *)infoDictionary
                                            customerId:(NSString *)customerid
                                     completionHandler:(void(^)(NSError * error))handler;
//删除储备客户
- (void)deleteChanceCustomerWithCustomerId:(NSString *)customerid
                         completionHandler:(void(^)(NSError * error))handler;
//新增联系记录
- (void)addContactRecordWithInfoDictionary:(NSDictionary *)infoDictionary
                         completionHandler:(void(^)(NSError * error))handler;
//修改联系记录
- (void)updateContactRecordWithInfoDictionary:(NSDictionary *)infoDictionary
                                     recordId:(NSString *)recordid
                            completionHandler:(void(^)(NSError * error))handler;
//删除联系记录
- (void)deleteContactRecordWithCustomerId:(NSString *)customerId
                                 recordId:(NSString *)recordId
                        completionHandler:(void (^)(NSError * error))handler;
//意见反馈
- (void)commitFeedbackWithContext:(NSString *)context
                completionHandler:(void(^)(NSError * error))handler;
//刷新customer数据
- (void)refreshCustomersCompletionHandler:(void(^)(NSError * error))handler;
//单例
+ (ZDModeClient *)sharedModeClient;

@end
