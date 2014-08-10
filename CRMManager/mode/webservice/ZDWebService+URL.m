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

- (NSURL *)URLForLogin
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_Base, @"login"]];
}

- (NSURL *)URLForGetCustomersCount
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Base,@"getCustomerCount"]];
}

- (NSURL *)URLForGetAllCustomers
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Base,@"getCustomers"]];
}

- (NSURL *)URLForGetAllProductsWithCustomer
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Base,@"getCustomerProducts"]];
}

- (NSURL *)URLForGetProductDetailWithProduct
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Base,@"getCustomerProductDetail"]];
}

@end
