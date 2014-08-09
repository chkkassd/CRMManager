//
//  ZDWebService+URL.m
//  CRMManager
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDWebService+URL.h"

#define API_Base @"https://api.ezendai.com/hera/manageraccount/"

@implementation ZDWebService (URL)

- (NSString *)URLForLogin
{
    return [NSString stringWithFormat:@"%@%@", API_Base, @"login"];
}

- (NSString *)URLForGetCustomersCount
{
    return [NSString stringWithFormat:@"%@%@",API_Base,@"getCustomerCount"];
}

- (NSString *)URLForGetAllCustomers
{
    return [NSString stringWithFormat:@"%@%@",API_Base,@"getCustomers"];
}
@end
