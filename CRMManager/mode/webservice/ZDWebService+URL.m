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
//http://172.16.230.187:9106/uc-server/index    用户名\密码 ：  admin\123456
@implementation ZDWebService (URL)

- (NSString *)baseUrlString
{
    return API_Base;
}

- (NSURL *)URLForLogin
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrlString], @"login"]];
}

- (NSURL *)URLForGetCustomersCount
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrlString],@"getCustomerCount"]];
}

- (NSURL *)URLForGetAllCustomers
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrlString],@"getCustomers"]];
}

- (NSURL *)URLForGetAllProductsWithCustomer
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrlString],@"getCustomerProducts"]];
}

- (NSURL *)URLForGetProductDetailWithProduct
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrlString],@"getCustomerProductDetail"]];
}

- (NSURL *)URLForGetAllBusinessWithCustomer
{
    return [NSURL URLWithString:@"http://172.16.6.108:8060/hera/credit/queryBusiness"];
    //https://172.16.230.190:8443/hera/
    //https://api.ezendai.com/hera/
}

- (NSURL *)URLForGetAllChanceCustomers
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrlString],@"querryCustomerList"]];
}

- (NSURL *)URLForGetCustomerContactLists
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrlString],@"querryContactRecordList"]];
}

// 新增储备客户的URL
- (NSURL *)URLForAddPotentialCustomer
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrlString],@"addReservesCustomer"]];
}

// 修改储备客户的URL
- (NSURL *)URLForUpdatePotentialCustomer
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrlString],@"updateReservesCustomer"]];
}

// 删除储备客户的URL
- (NSURL *)URLForDeletePotentialCustomer
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrlString],@"deleteReservesCustomer"]];
}

// 新增客户联系记录
- (NSURL *)URLForAddContact
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrlString],@"addContactRecord"]];
}

// 修改客户联系记录
- (NSURL *)URLForUpdateContact
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrlString],@"updateContactRecord"]];
}

// 删除客户联系记录
- (NSURL *)URLForDeleteContact
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrlString],@"deleteContactRecord"]];
}

//提交意见反馈
- (NSURL *)URLForCommitFeedback
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrlString],@"commitFeedback"]];
}

@end
