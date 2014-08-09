//
//  ZDWebService+URL.h
//  CRMManager
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.

//

#import "ZDWebService.h"

@interface ZDWebService (URL)

- (NSString *)URLForLogin;
- (NSString *)URLForGetAllCustomers;
//根据用户id得到所有的customers
- (NSString *)URLForGetCustomersCount;

@end
