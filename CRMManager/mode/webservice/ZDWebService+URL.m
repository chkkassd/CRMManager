//
//  ZDWebService+URL.m
//  CRMManager
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDWebService+URL.h"

#define API_Base @"https://api.ezendai.com/hera/manageraccount/"
#define API_Chance @"http://172.16.6.108:8060/hera/manageraccount/"

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

- (NSURL *)URLForGetAllBusinessWithCustomer
{
    return [NSURL URLWithString:@"https://api.ezendai.com/hera/credit/queryBusiness"];
    //https://172.16.230.190:8443/hera/
    //https://api.ezendai.com/hera/
}

- (NSURL *)URLForGetAllChanceCustomers
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"querryCustomerList"]];
}

- (NSURL *)URLForGetCustomerContactLists
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"querryContactRecordList"]];
}

// 新增储备客户的URL
- (NSURL *)URLForAddPotentialCustomer
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"addReservesCustomer"]];
}

// 修改储备客户的URL
- (NSURL *)URLForUpdatePotentialCustomer
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"updateReservesCustomer"]];
}

// 删除储备客户的URL
- (NSURL *)URLForDeletePotentialCustomer
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"deleteReservesCustomer"]];
}

// 新增客户联系记录
- (NSURL *)URLForAddContact
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"addContactRecord"]];
}

// 修改客户联系记录
- (NSURL *)URLForUpdateContact
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"updateContactRecord"]];
}

// 删除客户联系记录
- (NSURL *)URLForDeleteContact
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"deleteContactRecord"]];
}

@end
