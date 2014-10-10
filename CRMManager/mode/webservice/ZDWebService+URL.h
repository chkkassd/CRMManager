//
//  ZDWebService+URL.h
//  CRMManager
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.

//

#import "ZDWebService.h"



#define API_Base @"https://api.ezendai.com/hera/manageraccount/"
//#define API_Chance @"http://172.16.230.190:7070/hera/manageraccount/" //测试环境

#define API_HTTPS @"https://180.166.169.132:8444" //公网
#define API_Chance [NSString stringWithFormat:@"%@/hera/manageraccount/", API_HTTPS]




@interface ZDWebService (URL)

- (NSURL *)URLForLogin;
- (NSURL *)URLForGetAllCustomers;
- (NSURL *)URLForGetCustomersCount;
- (NSURL *)URLForGetAllProductsWithCustomer;
- (NSURL *)URLForGetProductDetailWithProduct;
//- (NSURL *)URLForGetAllBusinessWithCustomer;
- (NSURL *)URLForGetBusinessesWithCustomerId;
- (NSURL *)URLForGetBusinessesWithManagerId;

- (NSURL *)URLForGetAllChanceCustomers;
- (NSURL *)URLForGetCustomerContactLists;
- (NSURL *)URLForAddPotentialCustomer;
- (NSURL *)URLForUpdatePotentialCustomer;
- (NSURL *)URLForDeletePotentialCustomer;
- (NSURL *)URLForAddContact;
- (NSURL *)URLForUpdateContact;
- (NSURL *)URLForDeleteContact;
- (NSURL *)URLForCommitFeedback;
- (NSURL *)URLForGetRemindInfos;
- (NSURL *)URLForGetCreditRemindList;
- (NSURL *)URLForGetBirthRemindList;
- (NSURL *)URLForLoginOnWebByDimeCode;
- (NSURL *)URLForLoginOnWebByDimeCodeConfirm;
- (NSURL *)URLForLoginOnWebByDimeCodeCancle;
- (NSURL *)URLForqueryParams;

@end
