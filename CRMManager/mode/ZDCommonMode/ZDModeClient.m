//
//  ZDModeClient.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDModeClient.h"

@interface ZDModeClient()

@property (nonatomic) int defaultCount;

@end

@implementation ZDModeClient

#pragma mark - login and fetch data

//login and save all data
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSError *error))handler
{
    ZDManagerUser * managerUser = [[ZDManagerUser alloc] init];
    
    [[ZDWebService sharedWebViewService] loginWithUserName:userName password:password completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            //登陆成功
            
            //1.保存当前登录账号的userid
            [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"id"] forKey:DefaultCurrentUserId];
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
                        self.defaultCount = 0;
                        [self fetchAndSaveAllContractRecordsWithAllCustomers:self.allZDCustomers];
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
                int count = customers.count;
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
    if (self.defaultCount < customers.count) {
        [self fetchAndSaveAllContactRecordWithManagerUserId:self.zdManagerUser.userid
                                                 CustomerId:[customers[self.defaultCount] customerId]
                                          completionHandler:^(NSError *error) {
            if (!error) {
                NSLog(@"保存 customer:%@的record成功",[customers[self.defaultCount] customerId]);
                self.defaultCount++;
                [self fetchAndSaveAllContractRecordsWithAllCustomers:customers];
            } else {
                NSLog(@"保存 customer:%@的record失败",[customers[self.defaultCount] customerId]);
            }
        }];
    } else {
        //获取并保存完所有records后，发送更新records的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateContactRecordsNotification object:self];
    }
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

#pragma mark - 修改数据后保存

- (BOOL)saveZDManagerUser:(ZDManagerUser *)zdManageruser
{
    return [[ZDLocalDB sharedLocalDB] saveManagerUserWithZDManagerUser:zdManageruser error:NULL];
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

#pragma mark - 客户所有联系记录
- (NSArray *)zdContactRecordsWithCustomerId:(NSString *)customerid
{
    return [[ZDLocalDB sharedLocalDB] queryZDContactRecordsWithCustomerId:customerid];
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
