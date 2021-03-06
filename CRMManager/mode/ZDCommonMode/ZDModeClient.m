//
//  ZDModeClient.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDModeClient.h"

@interface ZDModeClient()

@end

@implementation ZDModeClient

#pragma mark - login and fetch data
//快速登陆
- (void)quickLoginWithManagerUserId:(NSString *)userid
{
    //3.获取并保存客户信息
    [self fetchAndSaveCustomersWithManagerUserId:userid completionHandler:^(NSError *error) {
        if (!error) {
            //4.获取并保存所有客户的联系记录
            [self fetchAndSaveAllContractRecordsWithAllCustomers:self.allZDCustomers];
            //5.获取并保存所有客户的business
            [self fetchAndSaveAllBusinessListsWithManagerId:self.zdManagerUser.userid];
            //6.获取生日提醒信息
            [self fetchAndSaveBirthRemindInfoWithManagerId:self.zdManagerUser.userid pageSize:@"200" pageNo:@"1"];
            //7.获取投资提醒信息
            [self fetchAndSaveInvestmentRemindInfoWithManagerId:self.zdManagerUser.userid pageSize:@"500" pageNo:@"1"];
            //8.获取CRMstate和fortuneState
            [self fetchAndSaveCRMState];
            [self fetchAndSaveFortuneState];
        } else {
            NSLog(@"保存customers失败");
        }
    }];
}

//login and save all data
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSError *error))handler
{
    ZDManagerUser * managerUser = [[ZDManagerUser alloc] init];
    
    [[ZDWebService sharedWebViewService] loginWithUserName:userName password:password completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            //登陆成功
            
            //1.保存当前登录账号的userid,账户名和密码
            [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"id"] forKey:DefaultCurrentUserId];
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:DefaultClientName];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:DefaultPassword];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
                //2.保存当前用户(managerUser)信息
                managerUser.userid = resultDic[@"id"];
                managerUser.password = password;
                if ([[ZDLocalDB sharedLocalDB] loginSaveManagerUserWithZDManagerUser:managerUser error:NULL]) {
                    //发送更新manageruser的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateManagerUserNotification object:self];
                    //保存完managerUser进入下一界面
                    handler(nil);
                    
                    //3.获取并保存客户信息
                    [self fetchAndSaveCustomersWithManagerUserId:managerUser.userid completionHandler:^(NSError *error) {
                        if (!error) {
                            //4.获取并保存所有客户的联系记录
                            [self fetchAndSaveAllContractRecordsWithAllCustomers:self.allZDCustomers];
                            //5.获取并保存所有客户的business
                            [self fetchAndSaveAllBusinessListsWithManagerId:self.zdManagerUser.userid];
                            //6.获取生日提醒信息
                            [self fetchAndSaveBirthRemindInfoWithManagerId:self.zdManagerUser.userid pageSize:@"50" pageNo:@"1"];
                            //7.获取投资提醒信息
                            [self fetchAndSaveInvestmentRemindInfoWithManagerId:self.zdManagerUser.userid pageSize:@"50" pageNo:@"1"];
                            //8.获取CRMstate和fortuneState
                            [self fetchAndSaveCRMState];
                            [self fetchAndSaveFortuneState];
                        } else {
                            NSLog(@"保存customers失败");
                        }
                    }];
                } else {
                    NSLog(@"保存managerUser失败");
                }
            
            
        } else {
            //登陆失败
            handler(error);
        }
    }];
}

//get and save all customers. if error is nil,save successfully,otherwise fail to save or fail to get data
- (void)fetchAndSaveCustomersWithManagerUserId:(NSString *)userid completionHandler:(void(^)(NSError *error))handler
{
    [[ZDWebService sharedWebViewService] fetchAllCustomersWithManagerUserId:userid
                                                                       type:@"0"
                                                          completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            NSArray * customers = resultDic[@"infos"];
            if (customers.count) {
                
                NSMutableArray *savedCustomers = [[NSMutableArray alloc] init];
                NSUInteger count = customers.count;
                for (int i = 0;i < count;i++) {
                    NSDictionary *dic = customers[i];
                    ZDCustomer *customer = [[ZDCustomer alloc] init];
                    customer.customerId = dic[@"customerId"];
                    customer.customerName = dic[@"customerName"];
                    customer.idNum = dic[@"idNum"];
                    customer.mobile = dic[@"mobile"];
                    customer.cdHope = dic[@"hope"];
                    customer.sex = dic[@"sex"];
                    customer.customerType = dic[@"customerType"];
                    customer.memo = dic[@"memo"];
                    [savedCustomers addObject:customer];
                }
                
                if ([[ZDLocalDB sharedLocalDB] saveMuchCustomersWith:savedCustomers error:NULL]) {
                    //发送更新customers的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateCustomersNotification object:self];
                    //保存成功
                    handler(nil);
                } else {
                    //保存失败
                    NSError * error = [[NSError alloc] init];
                    handler(error);
                }

            } else {
                //返回数据为空
                handler(nil);
            }
        } else {
            //请求数据失败
            handler(error);
        }
    }];
}

//get and save contactrecord of one customer.
- (void)fetchAndSaveAllContactRecordWithManagerUserId:(NSString *)userid
                                           CustomerId:(NSString *)customerid
                                    completionHandler:(void(^)(NSError * error))handler
{
    [[ZDWebService sharedWebViewService] fetchCustomerContactListWithManagerUserId:userid andCustomerId:customerid completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            NSArray * contactRecords = resultDic[@"infos"];
            if (contactRecords.count) {
                NSMutableArray *savedContactRecords = [[NSMutableArray alloc] init];
                NSUInteger count = contactRecords.count;
                for (int i = 0; i < count; i++) {
                    NSDictionary * record = contactRecords[i];
                    ZDContactRecord * zdContactRecord = [[ZDContactRecord alloc] init];
                    zdContactRecord.recordId = record[@"recordId"];
                    zdContactRecord.contactType = record[@"contactType"];
                    zdContactRecord.contactNum = record[@"contactNum"];
                    zdContactRecord.content = record[@"content"];
                    zdContactRecord.hope = record[@"hope"];
                    zdContactRecord.contactTime = record[@"contactTime"];
                    zdContactRecord.managerId = record[@"managerId"];
                    zdContactRecord.customerId = record[@"customerId"];
                    zdContactRecord.inputId = record[@"inputId"];
                    zdContactRecord.memo = record[@"memo"];
                    [savedContactRecords addObject:zdContactRecord];
                }
                
                if ([[ZDLocalDB sharedLocalDB] saveMuchContractRecordsWith:savedContactRecords error:NULL]) {
                    //保存成功
                    handler(nil);
                } else {
                    //保存失败
                    NSError * error = [[NSError alloc] init];
                    handler(error);
                }
            } else {
                //返回数据为空
                handler(nil);
            }
        } else {
            //请求数据失败
            handler(error);
        }
    }];
}

//get and save all records
- (void)fetchAndSaveAllContractRecordsWithAllCustomers:(NSArray *)customers
{
    if (!customers.count) return;
    
    __block int count = 0;
    for (ZDCustomer * customer in customers) {
        [self fetchAndSaveAllContactRecordWithManagerUserId:self.zdManagerUser.userid
                                                 CustomerId:[customer customerId]
                                          completionHandler:^(NSError *error) {
                                              if (!error) {
                                                  NSLog(@"save record of customerid:%@ success",customer.customerId);
                                              } else {
                                                  NSLog(@"save record of customerid:%@ fail",customer.customerId);
                                              }
                                              if (++count == customers.count) {
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateContactRecordsNotification object:self];
                                              }
                                          }];

    }
}

//get and save all businessLists

- (void)fetchAndSaveAllBusinessListsWithManagerId:(NSString *)managerid
{
    if (!managerid.length) return;
    
    [[ZDWebService sharedWebViewService] fetchBusinessesWithManagerId:self.zdManagerUser.userid completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            NSArray * infos = resultDic[@"infos"];
            NSMutableArray * zdBusinessLists = [[NSMutableArray alloc] init];
            NSMutableArray * businessCountArr = [[NSMutableArray alloc] init];
            NSMutableArray * zdCustomers = [[NSMutableArray alloc] init];
            [self modifyzdBusinessLists:zdBusinessLists andCountArr:businessCountArr FromInfosArr:infos];
            
            for (NSDictionary * dic in businessCountArr) {
                ZDCustomer * zdCustomer = [self zdCustomerWithCustomerId:dic[@"customerId"]];
                if (zdCustomer) {
                    zdCustomer.businessCount = dic[@"count"];
                    [zdCustomers addObject:zdCustomer];
                }
            }
            
            if ([[ZDLocalDB sharedLocalDB] saveMuchCustomersWith:zdCustomers error:NULL]) {
                [[ZDLocalDB sharedLocalDB] saveMuchBusinessList:zdBusinessLists error:NULL];
                [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateBusinessAndBusinessListsNotification object:self];
            }
            
        } else {
            NSLog(@"fail to fetch business from web");
        }
    }];
}

- (void)modifyzdBusinessLists:(NSMutableArray *)zdBusinessLists andCountArr:(NSMutableArray *)businessCountArr FromInfosArr:(NSArray *)infos
{
    for (NSDictionary * dic in infos) {
        if ([dic[@"busiCount"] intValue] > 0) {
            NSDictionary * countDic = @{@"customerId":dic[@"customerId"],@"count":dic[@"busiCount"]};
            [businessCountArr addObject:countDic];
        
            NSArray * businessListArr = dic[@"busiList"];
            for (NSDictionary * dic2 in businessListArr) {
                ZDBusinessList * zdBusinessList = [[ZDBusinessList alloc] init];
                zdBusinessList.customerId = dic2[@"customerId"];
                zdBusinessList.customerName = dic2[@"customerName"];
                zdBusinessList.endDate = dic2[@"endDate"];
                zdBusinessList.feLendNo = dic2[@"feLendNo"];
                zdBusinessList.crmState = dic2[@"crmState"];
                zdBusinessList.fortuneState = dic2[@"fortuneState"];
                zdBusinessList.investAmt = dic2[@"investAmt"];
                zdBusinessList.pattern = dic2[@"pattern"];
                [zdBusinessLists addObject:zdBusinessList];
            }
        }
    }
}

//get and save crmState
- (void)fetchAndSaveCRMState
{
    [[ZDWebService sharedWebViewService] fetchParamsWithParams:@"requestState" completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            NSDictionary * dic = resultDic[@"infos"];
            NSArray * arr = dic[@"requestState"];
            NSMutableDictionary * plistDic = [[NSMutableDictionary alloc] init];
            for (NSDictionary * stateDic in arr) {
                [plistDic setObject:stateDic[@"prName"] forKey:stateDic[@"prValue"]];
            }
            NSString * crmStatePath = [[ZDCachePathUtility sharedCachePathUtility] pathForCRMState];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:crmStatePath]) {
                if ([[NSFileManager defaultManager] removeItemAtPath:crmStatePath error:nil]) {
                    [plistDic writeToFile:crmStatePath atomically:YES];
                };
            } else {
                [plistDic writeToFile:crmStatePath atomically:YES];
            }
            
        } else {
            NSLog(@"fail to fetch CRMState from web");
        }
    }];
}

//get and save fortuneState
- (void)fetchAndSaveFortuneState
{
    [[ZDWebService sharedWebViewService] fetchParamsWithParams:@"FortuneState" completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            NSDictionary * dic = resultDic[@"infos"];
            NSArray * arr = dic[@"FortuneState"];
            NSMutableDictionary * plistDic = [[NSMutableDictionary alloc] init];
            for (NSDictionary * stateDic in arr) {
                [plistDic setObject:stateDic[@"prName"] forKey:stateDic[@"prValue"]];
            }
            NSString * fortuneStatePath = [[ZDCachePathUtility sharedCachePathUtility] pathForFortuneState];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:fortuneStatePath]) {
                if ([[NSFileManager defaultManager] removeItemAtPath:fortuneStatePath error:nil]) {
                    [plistDic writeToFile:fortuneStatePath atomically:YES];
                };
            } else {
                [plistDic writeToFile:fortuneStatePath atomically:YES];
            }
            
        } else {
            NSLog(@"fail to fetch fortuneState from web");
        }
    }];
}

//get and save birthRemind info
- (void)fetchAndSaveBirthRemindInfoWithManagerId:(NSString *)managerId
                                        pageSize:(NSString *)pageSize
                                          pageNo:(NSString *)pageNo
{
    [[ZDWebService sharedWebViewService] fetchBirthRemindListWithManagerId:managerId
                                                                  pageSize:pageSize
                                                                    pageNo:pageNo
                                                         completionHandler:^(NSError *error, NSDictionary *resultDic) {
                                                             if (!error) {
                                                                 NSArray * infosArr = resultDic[@"infos"];
                                                                 if (infosArr.count) {
                                                                     NSArray * birthReminds = [self birthRemindForInfos:infosArr];
                                                                     
                                                                     //保存
                                                                     if ([[ZDLocalDB sharedLocalDB] saveBirthReminds:birthReminds error:NULL]) {
                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateBirthRemindsNotification object:self];
                                                                     } else {
                                                                         NSLog(@"fail to save birthRemind");
                                                                     }
                                                                 }
                                                             } else {
                                                                 NSLog(@"fail to fetch birthReminds");
                                                             }
        
    }];
}

- (NSArray *)birthRemindForInfos:(NSArray *)infosArr
{
    NSMutableArray * birthReminds = [[NSMutableArray alloc] init];
    for (NSDictionary * dic in infosArr) {
        ZDBirthRemind * zdBirthRemind = [[ZDBirthRemind alloc] init];
        zdBirthRemind.dateOfBirth = dic[@"dataOfBirth"];
        zdBirthRemind.customerId = dic[@"custId"];
        [birthReminds addObject:zdBirthRemind];
    }
    return birthReminds;
}

//get and save investmentRemind
- (void)fetchAndSaveInvestmentRemindInfoWithManagerId:(NSString *)managerId
                                             pageSize:(NSString *)pageSize
                                               pageNo:(NSString *)pageNo
{
    [[ZDWebService sharedWebViewService] fetchCreditRemindListWithManagerId:managerId
                                                                   pageSize:pageSize
                                                                     pageNo:pageNo
                                                          completionHandler:^(NSError *error, NSDictionary *resultDic) {
                                                              if (!error) {
                                                                  NSArray * infosArr = resultDic[@"infos"];
                                                                  if (infosArr.count) {
                                                                      NSArray * investmentReminds = [self investmentRemindsForInfos:infosArr];
                                                                      if ([[ZDLocalDB sharedLocalDB] saveInvestmentReminds:investmentReminds error:NULL]) {
                                                                          [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateInvestmentRemindsNotification object:self];
                                                                      } else {
                                                                          NSLog(@"fail to save investmentRemind");
                                                                      }
                                                                  }
                                                              } else {
                                                                  NSLog(@"fail to fetch investmentRemind");
                                                              }
    }];
}

- (NSArray *)investmentRemindsForInfos:(NSArray *)infosArr
{
    if (!infosArr.count) return nil;
    NSMutableArray * investmentReminds = [[NSMutableArray alloc] init];
    for (NSDictionary * dic in infosArr) {
        ZDInvestmentRemind * zdInvestmentRemind = [[ZDInvestmentRemind alloc] init];
        zdInvestmentRemind.endDate = dic[@"endDate"];
        zdInvestmentRemind.investAmt = dic[@"investAmt"];
        zdInvestmentRemind.pattern = dic[@"pattern"];
        zdInvestmentRemind.customerId = dic[@"customerId"];
        zdInvestmentRemind.feLendNo = dic[@"feLendNo"];
        [investmentReminds addObject:zdInvestmentRemind];
    }
    return investmentReminds;
}

//刷新customer数据
- (void)refreshCustomersCompletionHandler:(void(^)(NSError * error))handler
{
    [self fetchAndSaveCustomersWithManagerUserId:self.zdManagerUser.userid completionHandler:^(NSError *error) {
        if (!error) {
            handler(nil);
        } else {
            handler(error);
        }
    }];
}

//刷新one customer contactrecord数据
- (void)refreshContactRecordsWithCustomerId:(NSString *)customerId
                          CompletionHandler:(void (^)(NSError *))handler
{
    [self fetchAndSaveAllContactRecordWithManagerUserId:self.zdManagerUser.userid CustomerId:customerId completionHandler:^(NSError *error) {
        if (!error) {
            handler(nil);
        } else {
            handler(error);
        }
    }];
}

//刷新所有businesslist数据

- (void)fetchAndSaveAllBusinessListsWithManagerId:(NSString *)managerid
                                completionHandler:(void(^)(NSError * error))handler
{
    if (!managerid.length) return;
    
    [[ZDWebService sharedWebViewService] fetchBusinessesWithManagerId:self.zdManagerUser.userid completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            NSArray * infos = resultDic[@"infos"];
            NSMutableArray * zdBusinessLists = [[NSMutableArray alloc] init];
            NSMutableArray * businessCountArr = [[NSMutableArray alloc] init];
            NSMutableArray * zdCustomers = [[NSMutableArray alloc] init];
            [self modifyzdBusinessLists:zdBusinessLists andCountArr:businessCountArr FromInfosArr:infos];
            
            for (NSDictionary * dic in businessCountArr) {
                ZDCustomer * zdCustomer = [self zdCustomerWithCustomerId:dic[@"customerId"]];
                if (zdCustomer) {
                    zdCustomer.businessCount = dic[@"count"];
                    [zdCustomers addObject:zdCustomer];
                }
            }
            
            if ([[ZDLocalDB sharedLocalDB] saveMuchCustomersWith:zdCustomers error:NULL]) {
                [[ZDLocalDB sharedLocalDB] saveMuchBusinessList:zdBusinessLists error:NULL];
                handler(nil);
            }
            
        } else {
            handler(error);
            NSLog(@"fail to fetch business from web");
        }
    }];
}

#pragma mark - 修改数据后保存

- (BOOL)saveZDManagerUser:(ZDManagerUser *)zdManageruser
{
    if ([[ZDLocalDB sharedLocalDB] saveManagerUserWithZDManagerUser:zdManageruser error:NULL]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateManagerUserNotification object:self];
        return YES;
    }
    return NO;
}

//新增储备客户
- (void)addChanceCustomerWithCustomerInfoDictionary:(NSDictionary *)infoDictionary
                                  completionHandler:(void(^)(NSError * error))handler
{
    [[ZDWebService sharedWebViewService] addPotentialCustomerWithCustomerName:infoDictionary[@"customerName"]
                                                                          sex:infoDictionary[@"sex"]
                                                                    managerId:infoDictionary[@"managerId"]
                                                                       mobile:infoDictionary[@"mobile"]
                                                                         memo:infoDictionary[@"memo"]
                                                                         hope:infoDictionary[@"hope"]
                                                                       source:infoDictionary[@"source"]
                                                                         area:infoDictionary[@"area"]
                                                            completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            //添加成功,存入coredata
            ZDCustomer * zdCustomer = [self manageZDCustomerFromInfoDictionary:infoDictionary andCustomerId:resultDic[@"customerId"]];
            if ([[ZDLocalDB sharedLocalDB] saveCustomerWith:zdCustomer error:NULL]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateCustomersNotification object:self];
                handler(nil);
            }
        } else {
            handler(error);
        }
    }];
}

- (ZDCustomer *)manageZDCustomerFromInfoDictionary:(NSDictionary *)infoDic andCustomerId:(NSString *)customerid
{
    ZDCustomer * zdCustomer = [[ZDCustomer alloc] init];
    zdCustomer.customerId = customerid;
    zdCustomer.customerName = infoDic[@"customerName"];
    zdCustomer.idNum = @"";
    zdCustomer.mobile = infoDic[@"mobile"];
    zdCustomer.cdHope = infoDic[@"hope"];
    zdCustomer.customerType = @"1";
    zdCustomer.sex = infoDic[@"sex"];
    zdCustomer.memo = infoDic[@"memo"];
    return zdCustomer;
}

//更新储备客户
- (void)updateChanceCustomerWithCustomerInfoDictionary:(NSDictionary *)infoDictionary
                                            customerId:(NSString *)customerid
                                     completionHandler:(void(^)(NSError * error))handler
{
    [[ZDWebService sharedWebViewService] updatePotentialCustomerWithCustomerName:infoDictionary[@"customerName"]
                                                                             sex:infoDictionary[@"sex"]
                                                                       managerId:infoDictionary[@"managerId"]
                                                                          mobile:infoDictionary[@"mobile"]
                                                                            memo:infoDictionary[@"memo"]
                                                                            hope:infoDictionary[@"hope"]
                                                                          source:infoDictionary[@"source"]
                                                                   andCustomerId:customerid
                                                               completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            //修改成功,存入coredata
            ZDCustomer * zdCustomer = [self manageZDCustomerFromInfoDictionary:infoDictionary andCustomerId:customerid];
            if ([[ZDLocalDB sharedLocalDB] saveCustomerWith:zdCustomer error:NULL]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateCustomersNotification object:self];
                handler(nil);
            }
        } else {
            handler(error);
        }
    }];
}

//删除储备客户
- (void)deleteChanceCustomerWithCustomerId:(NSString *)customerid
                         completionHandler:(void(^)(NSError * error))handler
{
    [[ZDWebService sharedWebViewService] deletePotentialCustomerWithCustomerId:customerid
                                                             completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            //从数据库删除
            if ([[ZDLocalDB sharedLocalDB] deleteOneCustomerWithCustomerId:customerid error:NULL]) {
                //数据库删除成功，发通知
                [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateCustomersNotification object:self];
                handler(nil);
            }
        } else {
            handler(error);
        }
    }];
}

//新增联系记录
- (void)addContactRecordWithInfoDictionary:(NSDictionary *)infoDictionary
                         completionHandler:(void(^)(NSError * error))handler
{
    [[ZDWebService sharedWebViewService] addContactRecordWithManagerId:infoDictionary[@"managerId"]
                                                            customerId:infoDictionary[@"customerId"]
                                                           contactType:infoDictionary[@"contactType"]
                                                            contactNum:infoDictionary[@"contactNum"]
                                                               content:infoDictionary[@"content"]
                                                                  hope:infoDictionary[@"hope"]
                                                           contactTime:infoDictionary[@"contactTime"]
                                                             inputDate:infoDictionary[@"inputDate"]
                                                               inputId:infoDictionary[@"inputId"]
                                                                  memo:infoDictionary[@"memo"]
                                                               handler:^(NSError *error, NSDictionary *resultDic) {
                                                                   if (!error) {
                                                                       //保存到coredata
                                                                       ZDContactRecord * zdContactRecord = [self manageZDContactRecordWithInfoDictionary:infoDictionary andRecordId:resultDic[@"recordId"]];
                                                                       if ([[ZDLocalDB sharedLocalDB] saveContactRecordWith:zdContactRecord error:NULL]) {
                                                                           [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateContactRecordsNotification object:self];
                                                                           handler(nil);
                                                                       }
                                                                   } else {
                                                                       handler(error);
                                                                   }
                                                            }];
}

- (ZDContactRecord *)manageZDContactRecordWithInfoDictionary:(NSDictionary *)infoDictionary andRecordId:(NSString *)recordid
{
    ZDContactRecord * zdContactRecord = [[ZDContactRecord alloc] init];
    zdContactRecord.recordId = recordid;
    zdContactRecord.contactType = infoDictionary[@"contactType"];
    zdContactRecord.contactNum = infoDictionary[@"contactNum"];
    zdContactRecord.content = infoDictionary[@"content"];
    zdContactRecord.hope = infoDictionary[@"hope"];
    zdContactRecord.contactTime = infoDictionary[@"contactTime"];
    zdContactRecord.managerId = infoDictionary[@"managerId"];
    zdContactRecord.customerId = infoDictionary[@"customerId"];
    zdContactRecord.inputId = infoDictionary[@"inputId"];
    zdContactRecord.memo = infoDictionary[@"memo"];
    return zdContactRecord;
}


//修改联系记录
- (void)updateContactRecordWithInfoDictionary:(NSDictionary *)infoDictionary
                                             recordId:(NSString *)recordid
                                 completionHandler:(void(^)(NSError * error))handler
{
    [[ZDWebService sharedWebViewService] updateContactRecordWithManagerId:infoDictionary[@"managerId"]
                                                               customerId:infoDictionary[@"customerId"]
                                                              contactType:infoDictionary[@"contactType"]
                                                               contactNum:infoDictionary[@"contactNum"]
                                                                  content:infoDictionary[@"content"]
                                                                     hope:infoDictionary[@"hope"]
                                                              contactTime:infoDictionary[@"contactTime"]
                                                                inputDate:infoDictionary[@"inputDate"]
                                                                  inputId:infoDictionary[@"inputId"]
                                                                     memo:infoDictionary[@"memo"]
                                                                 recordId:recordid
                                                                  handler:^(NSError *error, NSDictionary *resultDic) {
                                                                      if (!error) {
                                                                          //保存到数据库
                                                                          ZDContactRecord * zdContactRecord = [self manageZDContactRecordWithInfoDictionary:infoDictionary andRecordId:recordid];
                                                                          if ([[ZDLocalDB sharedLocalDB] saveContactRecordWith:zdContactRecord error:NULL]) {
                                                                              [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateContactRecordsNotification object:self];
                                                                              handler(nil);
                                                                          }
                                                                      } else {
                                                                          handler(error);
                                                                      }
     }];

}

//删除联系记录
- (void)deleteContactRecordWithCustomerId:(NSString *)customerId
                                 recordId:(NSString *)recordId
                        completionHandler:(void (^)(NSError * error))handler
{
    [[ZDWebService sharedWebViewService] deleteContactRecordWithCustomerId:customerId
                                                                  recordId:recordId completionHandler:^(NSError *error, NSDictionary *resultDic) {
                                                                      if (!error) {
                                                                          //从数据库中删除
                                                                          if([[ZDLocalDB sharedLocalDB] deleteOneContactRecordWithReocrdId:recordId error:NULL]) {
                                                                              [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateContactRecordsNotification object:self];
                                                                              handler(nil);
                                                                          }
                                                                      } else {
                                                                          handler(error);
                                                                      }
                                                                  }];
}

//意见反馈
- (void)commitFeedbackWithContext:(NSString *)context
                       completionHandler:(void(^)(NSError * error))handler
{
    NSDictionary* info = [[NSBundle mainBundle] infoDictionary];
    NSString * appVersion = info[@"CFBundleShortVersionString"];
    NSString * systemVersion = [[UIDevice currentDevice] systemVersion];
    
    [[ZDWebService sharedWebViewService] commitFeedbackWithManagerId:self.zdManagerUser.userid Context:context OperDate:[NSString stringTranslatedFromDate:[NSDate date]] AppType:@"iphone" AppVersion:appVersion System:@"ios" SystemVersion:systemVersion completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            //成功
            handler(nil);
        } else {
            //失败
            handler(error);
        }
    }];
}

//删除investmentRemind
- (BOOL)deleteInvestmentRemindWithZDInvestmentRemind:(ZDInvestmentRemind *)zdInvestmentRemind
{
    return [[ZDLocalDB sharedLocalDB] deleteOneInvestmentRemindWithCustomerId:zdInvestmentRemind.customerId feLendNo:zdInvestmentRemind.feLendNo error:NULL];
}

//删除birthRemind
//- (BOOL)deleteBirthRemindWithCustomerId:(NSString *)customerid
//{
//    return [[ZDLocalDB sharedLocalDB] deleteOneBirthRemindWithCustomerId:customerid error:NULL];
//}

#pragma mark - 二维码扫描登录相关

- (void)scanToLoginOnWebByUserName:(NSString *)userName
                          dimeCode:(NSString *)dimeCode
                 completionHandler:(void(^)(NSError * error))handler
{
    [[ZDWebService sharedWebViewService] CRMLoginOnWebWithUserName:userName
                                                          dimeCode:dimeCode
                                                 completionHandler:^(NSError *error, NSDictionary *resultDic) {
                                                     if (!error) {
                                                         handler(nil);
                                                     } else {
                                                         handler(error);
                                                     }
    }];
}

- (void)scanToLoginOnWebConfirmByDimeCode:(NSString *)dimeCode
                        completionHandler:(void(^)(NSError * error))handler
{
    [[ZDWebService sharedWebViewService] confirmCRMLoginOnWebWithdimeCode:dimeCode
                                                        completionHandler:^(NSError *error, NSDictionary *resultDic) {
                                                            if (!error) {
                                                                handler(nil);
                                                            } else {
                                                                handler(error);
                                                            }
    }];
}

- (void)scanToLoginOnWebCancleByDimeCode:(NSString *)dimeCode
                       completionHandler:(void(^)(NSError * error))handler
{
    [[ZDWebService sharedWebViewService] cancleCRMLoginOnWebWithdimeCode:dimeCode
                                                       completionHandler:^(NSError *error, NSDictionary *resultDic) {
                                                           if (!error) {
                                                               handler(nil);
                                                           } else {
                                                               handler(error);
                                                           }
    }];
}

#pragma mark - 地区参数

- (void)fetchAreaParamsCompletionHandler:(void(^)(NSError * error, NSArray * areas))handler
{
    [[ZDWebService sharedWebViewService] fetchParamsWithParams:@"OrganFortune" completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            NSDictionary * dic = resultDic[@"infos"];
            NSArray * array = dic[@"OrganFortune"];
            handler(nil,array);
        } else {
            handler(error,nil);
        }
    }];
}

#pragma mark - 客户所有联系记录
- (NSArray *)zdContactRecordsWithCustomerId:(NSString *)customerid
{
    NSArray * arr = [[ZDLocalDB sharedLocalDB] queryZDContactRecordsWithCustomerId:customerid];
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"contactTime" ascending:NO];
    
    return [arr sortedArrayUsingDescriptors:@[sortDescriptor]];
}

#pragma mark - 客户的所有businessList
- (NSArray *)zdBusinessListsWithCustomerId:(NSString *)customerid
{
    return [[ZDLocalDB sharedLocalDB] queryAllZDBusinessListsWithCustomerId:customerid];
}

#pragma mark - 客户的生日提醒
- (NSString *)birthRemindWithCustomerId:(NSString *)customerid
{
    return [[[ZDLocalDB sharedLocalDB] queryBirthRemindByRelationshipWithCustomerId:customerid] dataOfBirth];
}

#pragma mark - 客户投资到期提醒
- (NSArray *)investmentRemindWithCustomerId:(NSString *)customerid
{
    return [[ZDLocalDB sharedLocalDB] queryAllZDInvestmentRemindsWithCustomerId:customerid];
}

- (ZDInvestmentRemind *)investmentRemindWithCustomerId:(NSString *)customerid andFeLendNo:(NSString *)feLendNo
{
    return [[ZDLocalDB sharedLocalDB] queryZDInvestmentRemindWithCustomerId:customerid andFeLendNo:feLendNo];
}

- (ZDCustomer *)zdCustomerWithCustomerId:(NSString *)customerid
{
    return [[ZDLocalDB sharedLocalDB] queryZDCustomerWithCustomerId:customerid];
}

#pragma mark - properties

- (ZDManagerUser *)zdManagerUser
{
    _zdManagerUser = [[ZDLocalDB sharedLocalDB] queryCurrentZDmanagerUser];
    return _zdManagerUser;
}

- (NSArray *)allZDCustomers
{
    _allZDCustomers = [[ZDLocalDB sharedLocalDB] queryAllZDCustomersOfCurrentManager];
    return _allZDCustomers;
}

- (NSArray *)allZDChanceCustomers
{
    _allZDChanceCustomers = [[ZDLocalDB sharedLocalDB] queryAllZDChanceCustomersOfCurrentManager];
    
    return _allZDChanceCustomers;
}

- (NSArray *)allZDCurrentCustomers
{
    return [[ZDLocalDB sharedLocalDB] queryAllZDCurrentCustomersOfCurrentManager];    
}

#pragma mark - sharedInstance

+ (ZDModeClient *)sharedModeClient
{
    static dispatch_once_t once;
    static ZDModeClient *sharedclient;
    dispatch_once(&once, ^{
        sharedclient = [[self alloc] init];
    });
    return sharedclient;
}

@end
