//
//  ZDWebService+URL.h
//  CRMManager
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.

//

#import "ZDWebService.h"

#define API_Official @"https://api.ezendai.com"//公网正式
//#define API_Official @"https://180.166.169.132:8444" //公网测试
#define API_Chance [NSString stringWithFormat:@"%@/hera/manageraccount/", API_Official]

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
