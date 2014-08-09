//
//  ZDWebService+URL.h
//  CRMManager
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.

//

#import "ZDWebService.h"

@interface ZDWebService (URL)

- (NSURL *)URLForLogin;
- (NSURL *)URLForGetAllCustomers;
- (NSURL *)URLForGetCustomersCount;

@end
