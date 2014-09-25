//
//  ZDWebService.h
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.

//管理所有webservice接口的类

#import <Foundation/Foundation.h>
#import "AllCustomerCategoryHeaders.h"

@interface ZDWebService : NSObject

//登陆接口
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler;

//根据用户id得到所有的customers的总数量
- (void)fetchCustomersCountWithManagerUserId:(NSString *)userid completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler;

//根据用户id得到所有的customers
- (void)fetchCustomersWithManagerUserId:(NSString *)userid completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler;

//根据cusmomerid得到其所有的产品
- (void)fetchProductsWithCustomerId:(NSString *)customerid completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler;

//根据productid得到产品详情
- (void)fetchProductDetailWithProductId:(NSString *)productid completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler;

//根据customer的mobile查询其业务
//- (void)fetchBusinessWithCustomerMobile:(NSString *)mobile andBusinessType:(NSString *)type completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;
- (void)fetchBusinessesWithCustomerId:(NSString *)customerid completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler;
- (void)fetchBusinessesWithManagerId:(NSString *)managerid completionHandler:(void(^)(NSError *error, NSDictionary *resultDic))handler;


//新接口
//获取所有客户列表，用于机会页面
- (void)fetchAllCustomersWithManagerUserId:(NSString *)userid
                                      type:(NSString *)type
                               completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

//获取客户联系纪录列表
- (void)fetchCustomerContactListWithManagerUserId:(NSString *)userid andCustomerId:(NSString *)customerid completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

// 新增储备客户
- (void)addPotentialCustomerWithCustomerName:(NSString *)customerName
                         sex:(NSString *)sex
                   managerId:(NSString *)managerId
                      mobile:(NSString *)mobile
                        memo:(NSString *)memo
                        hope:(NSString *)hope
                      source:(NSString *)source
                        area:(NSString *)areaValue
           completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

// 更改储备客户
- (void)updatePotentialCustomerWithCustomerName:(NSString *)customerName
                         sex:(NSString *)sex
                   managerId:(NSString *)managerId
                      mobile:(NSString *)mobile
                        memo:(NSString *)memo
                        hope:(NSString *)hope
                      source:(NSString *)source
               andCustomerId:(NSString *)customerId
           completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

// 删除储备客户
- (void)deletePotentialCustomerWithCustomerId:(NSString *)customerId
              completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

// 新增客户联系记录
- (void)addContactRecordWithManagerId:(NSString *)managerId
              customerId:(NSString *)customerId
             contactType:(NSString *)contactType
              contactNum:(NSString *)contactNum
                 content:(NSString *)content
                    hope:(NSString *)hope
             contactTime:(NSString *)contactTime
               inputDate:(NSString *)inputDate
                 inputId:(NSString *)inputId
                    memo:(NSString *)memo
                 handler:(void (^)(NSError *error, NSDictionary *resultDic))handler;

// 修改客户联系记录
- (void)updateContactRecordWithManagerId:(NSString *)managerId
                 customerId:(NSString *)customerId
                contactType:(NSString *)contactType
                 contactNum:(NSString *)contactNum
                    content:(NSString *)content
                       hope:(NSString *)hope
                contactTime:(NSString *)contactTime
                  inputDate:(NSString *)inputDate
                    inputId:(NSString *)inputId
                       memo:(NSString *)memo
                   recordId:(NSString *)recordId
                    handler:(void (^)(NSError *error, NSDictionary *resultDic))handler;

// 删除客户联系记录
- (void)deleteContactRecordWithCustomerId:(NSString *)customerId
                   recordId:(NSString *)recordId
          completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

//意见反馈
- (void)commitFeedbackWithManagerId:(NSString *)managerId
                            Context:(NSString *)context
                           OperDate:(NSString *)operDate
                            AppType:(NSString *)appType
                         AppVersion:(NSString *)appVersion
                             System:(NSString *)system
                      SystemVersion:(NSString *)systemVersion
                  completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

//登录后获取提醒信息
- (void)fetchRemindInfosWithManagerId:(NSString *)managerId
                    completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

//查看投资到期提醒信息列表
- (void)fetchCreditRemindListWithManagerId:(NSString *)managerId
                                  pageSize:(NSString *)pageSize
                                    pageNo:(NSString *)pageNo
                         completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

//查看生日到期提醒信息列表
- (void)fetchBirthRemindListWithManagerId:(NSString *)managerId
                                 pageSize:(NSString *)pageSize
                                   pageNo:(NSString *)pageNo
                        completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

//二维码扫描登录
- (void)CRMLoginOnWebWithUserName:(NSString *)userName
                         dimeCode:(NSString *)dimeCode
                completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

//二维码扫描确认登录
- (void)confirmCRMLoginOnWebWithdimeCode:(NSString *)dimeCode
                       completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

//二维码扫描取消登录
- (void)cancleCRMLoginOnWebWithdimeCode:(NSString *)dimeCode
                      completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;
//获取参数
- (void)fetchParamsWithParams:(NSString *)params
            completionHandler:(void(^)(NSError * error,NSDictionary * resultDic))handler;

//单例
+(ZDWebService *)sharedWebViewService;

@end
