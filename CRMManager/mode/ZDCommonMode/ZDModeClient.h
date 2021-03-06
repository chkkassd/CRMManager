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
#import "AllCustomerCategoryHeaders.h"
#import "ZDBusinessList.h"
#import "ZDBirthRemind.h"
#import "ZDInvestmentRemind.h"

#define DefaultCurrentUserId    @"DefaultCurrentUserId"
#define DefaultClientName   @"DefaultClientName"
#define DefaultPassword     @"DefaultPassword"
#define ZDUpdateManagerUserNotification  @"UpdateManagerUserNotification"
#define ZDUpdateCustomersNotification  @"UpdateCustomersNotification"
#define ZDUpdateContactRecordsNotification  @"UpdateContactRecordsNotification"
#define ZDUpdateBusinessAndBusinessListsNotification  @"UpdateBusinessAndBusinessListsNotification"
#define ZDUpdateBirthRemindsNotification  @"updateBirthRemindsNotification"
#define ZDUpdateInvestmentRemindsNotification  @"updateInvestmentRemindsNotification"

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
//得到一个客户的生日提醒
- (NSString *)birthRemindWithCustomerId:(NSString *)customerid;
//得到一个客户的所有投资到期提醒
- (NSArray *)investmentRemindWithCustomerId:(NSString *)customerid;
//查询一个特定的投资提醒
- (ZDInvestmentRemind *)investmentRemindWithCustomerId:(NSString *)customerid
                                           andFeLendNo:(NSString *)feLendNo;

#pragma makr - 修改manager和customer
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

//删除投资提醒
- (BOOL)deleteInvestmentRemindWithZDInvestmentRemind:(ZDInvestmentRemind *)zdInvestmentRemind;

//删除生日提醒
//- (BOOL)deleteBirthRemindWithCustomerId:(NSString *)customerid;

//刷新customer数据
- (void)refreshCustomersCompletionHandler:(void(^)(NSError * error))handler;

//刷新one customer record数据
- (void)refreshContactRecordsWithCustomerId:(NSString *)customerId
                          CompletionHandler:(void(^)(NSError * error))handler;

//刷新所有businesslist数据
- (void)fetchAndSaveAllBusinessListsWithManagerId:(NSString *)managerid
                                completionHandler:(void(^)(NSError * error))handler;

- (void)fetchAndSaveAllBusinessListsWithManagerId:(NSString *)managerid;

- (void)fetchAndSaveBirthRemindInfoWithManagerId:(NSString *)managerId
                                        pageSize:(NSString *)pageSize
                                          pageNo:(NSString *)pageNo;

- (void)fetchAndSaveInvestmentRemindInfoWithManagerId:(NSString *)managerId
                                             pageSize:(NSString *)pageSize
                                               pageNo:(NSString *)pageNo;

#pragma mark - 扫描二维码相关
- (void)scanToLoginOnWebByUserName:(NSString *)userName
                          dimeCode:(NSString *)dimeCode
                 completionHandler:(void(^)(NSError * error))handler;

- (void)scanToLoginOnWebConfirmByDimeCode:(NSString *)dimeCode
                        completionHandler:(void(^)(NSError * error))handler;

- (void)scanToLoginOnWebCancleByDimeCode:(NSString *)dimeCode
                       completionHandler:(void(^)(NSError * error))handler;

#pragma mark - 地区参数
- (void)fetchAreaParamsCompletionHandler:(void(^)(NSError * error, NSArray * areas))handler;

//单例
+ (ZDModeClient *)sharedModeClient;

@end
