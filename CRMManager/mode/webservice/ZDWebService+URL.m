//
//  ZDWebService+URL.m
//  CRMManager
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDWebService+URL.h"

#define API_Base @"https://api.ezendai.com/hera/manageraccount/"
//#define API_Chance @"http://172.16.230.190:7070/hera/manageraccount/"
//#define API_Chance @"https://api.ezendai.com/hera/manageraccount/"

//http://172.16.230.187:9106/uc-server/index    用户名\密码 ：  admin\123456

#define API_Chance @"http://121.199.0.190:8080/hera2/manageraccount/"


@implementation ZDWebService (URL)

- (NSURL *)URLForLogin
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_Chance, @"login"]];
}

- (NSURL *)URLForGetCustomersCount
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"getCustomerCount"]];
}

- (NSURL *)URLForGetAllCustomers
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"getCustomers"]];
}

- (NSURL *)URLForGetAllProductsWithCustomer
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"getCustomerProducts"]];
}

- (NSURL *)URLForGetProductDetailWithProduct
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"getCustomerProductDetail"]];
}

- (NSURL *)URLForGetAllBusinessWithCustomer
{
//    return [NSURL URLWithString:@"http://172.16.6.108:8060/hera/credit/queryBusiness"];//172.16.55.241.
    
//    return [NSURL URLWithString:@"http://121.199.0.190:8080/hera3/credit/queryBusiness"];//172.16.55.241.
    return [NSURL URLWithString:@"http://172.16.230.190:7070/hera/credit/queryBusiness"];
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

//提交意见反馈
- (NSURL *)URLForCommitFeedback
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"commitFeedback"]];
}

//登录后获取提醒信息
- (NSURL *)URLForGetRemindInfos
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"getRemindInfos"]];
}

//登录后获取投资到期提醒列表
- (NSURL *)URLForGetCreditRemindList
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"creditList"]];
}

//登录后获取投资到期提醒列表
- (NSURL *)URLForGetBirthRemindList
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Chance,@"birthList"]];
}

@end
