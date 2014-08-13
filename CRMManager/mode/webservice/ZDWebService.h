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
- (void)fetchBusinessWithCustomerMobile:(NSString *)mobile andBusinessType:(NSString *)type completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

//获取储备客户列表，用于机会页面
- (void)fetchAllChanceCustomersWithManagerUserId:(NSString *)userid completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

//获取客户联系纪录列表
- (void)fetchCustomerContactListWithManagerUserId:(NSString *)userid andCustomerId:(NSString *)customerid completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

// 新增储备客户
- (void)addPotentialCustomer:(NSString *)customerName
                         sex:(NSString *)sex
                   managerId:(NSString *)managerId
                      mobile:(NSString *)mobile
                        memo:(NSString *)memo
                        hope:(NSString *)hope
                      source:(NSString *)source
           completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

// 更改储备客户
- (void)updatePotentialCustomer:(NSString *)customerName
                         sex:(NSString *)sex
                   managerId:(NSString *)managerId
                      mobile:(NSString *)mobile
                        memo:(NSString *)memo
                        hope:(NSString *)hope
                      source:(NSString *)source
               andCustomerId:(NSString *)customerId
           completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

// 删除储备客户
- (void)deletePotentialCustomer:(NSString *)customerId
              completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

// 新增客户联系记录
- (void)addContactRecord:(NSString *)managerId
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
- (void)updateContactRecord:(NSString *)managerId
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

// 删除储备客户
- (void)deleteContactRecord:(NSString *)customerId
                   recordId:(NSString *)recordId
          completionHandler:(void(^)(NSError * error, NSDictionary * resultDic))handler;

//单例
+(ZDWebService *)sharedWebViewService;

@end
