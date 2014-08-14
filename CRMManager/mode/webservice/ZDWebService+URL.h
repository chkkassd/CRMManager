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
- (NSURL *)URLForGetAllProductsWithCustomer;
- (NSURL *)URLForGetProductDetailWithProduct;
- (NSURL *)URLForGetAllBusinessWithCustomer;
- (NSURL *)URLForGetAllChanceCustomers;
- (NSURL *)URLForGetCustomerContactLists;
- (NSURL *)URLForAddPotentialCustomer;
- (NSURL *)URLForUpdatePotentialCustomer;
- (NSURL *)URLForDeletePotentialCustomer;
- (NSURL *)URLForAddContact;
- (NSURL *)URLForUpdateContact;
- (NSURL *)URLForDeleteContact;
- (NSURL *)URLForCommitFeedback;

@end
