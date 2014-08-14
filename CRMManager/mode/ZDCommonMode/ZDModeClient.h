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

@interface ZDModeClient : NSObject

//login
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSError *error))handler;

//modify and save
- (BOOL)saveZDManagerUser:(ZDManagerUser *)zdManageruser;

//common propertise
@property (strong, nonatomic) ZDManagerUser *zdManagerUser;//当前使用用户
@property (strong, nonatomic) NSArray * allZDCustomers;//当前manager的所有customers

//单例
+ (ZDModeClient *)sharedModeClient;

- (void)fetchAndSaveAllContactRecordWithManagerUserId:(NSString *)userid
                                           CustomerId:(NSString *)customerid
                                    completionHandler:(void(^)(NSError * error))handler;
@end
