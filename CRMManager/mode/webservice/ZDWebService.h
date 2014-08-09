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
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSString *obj,NSError *error))handler;

//根据用户id得到所有的customers的总数量
- (void)fetchCustomersCountWithManagerUserId:(NSString *)userid completionHandler:(void(^)(NSString *state,NSError *error,NSString *count))handler;

//单例
+(ZDWebService *)sharedWebViewService;

@end
