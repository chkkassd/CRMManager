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
                        //发送更新customers的通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateCustomersNotification object:self];
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
    [[ZDWebService sharedWebViewService] fetchCustomersWithManagerUserId:userid completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            NSArray * customers = resultDic[@"infos"];
            if (customers.count) {
                
                NSMutableArray *savedCustomers = [[NSMutableArray alloc] init];
                int count = [resultDic[@"count"] intValue];
                for (int i = 0;i < count;i++) {
                    NSDictionary *dic = customers[i];
                    ZDCustomer *customer = [[ZDCustomer alloc] init];
                    customer.customerId = dic[@"customerId"];
                    customer.customerName = dic[@"customerName"];
                    customer.idNum = dic[@"idNum"];
                    customer.mobile = dic[@"mobile"];
                    customer.cdHope = dic[@"cdHope"];
                    customer.date = dic[@"dt"];
                    customer.customerType = dic[@"customerType"];
                    [savedCustomers addObject:customer];
                }
                
                if ([[ZDLocalDB sharedLocalDB] saveMuchCustomersWith:savedCustomers error:NULL]) {
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

- (void)fetchAndSaveAllContractRecordsWithAllCustomers:(NSArray *)customers
{
    if (self.defaultCount < customers.count) {
        [self fetchAndSaveAllContactRecordWithManagerUserId:self.zdManagerUser.userid CustomerId:[customers[self.defaultCount] customerId] completionHandler:^(NSError *error) {
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

#pragma mark - 修改数据后保存

- (BOOL)saveZDManagerUser:(ZDManagerUser *)zdManageruser
{
    return [[ZDLocalDB sharedLocalDB] saveManagerUserWithZDManagerUser:zdManageruser error:NULL];
}

//新增储备客户
- (void)addChanceCustomerWithCustomerInfoDictionary:(NSDictionary *)infoDictionary
                                  completionHandler:(void(^)(NSError * error))handler
{
    [[ZDWebService sharedWebViewService] addPotentialCustomerWithCustomerName:infoDictionary[@"customerName"] sex:infoDictionary[@"sex"] managerId:infoDictionary[@"managerId"] mobile:infoDictionary[@"mobile"] memo:infoDictionary[@"memo"] hope:infoDictionary[@"hope"] source:infoDictionary[@"source"] completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            //添加成功,存入coredata
            ZDCustomer * zdCustomer = [self manageZDCustomerFromInfoDictionary:infoDictionary andCustomerId:resultDic[@"customerId"]];
            if ([[ZDLocalDB sharedLocalDB] saveCustomerWith:zdCustomer error:NULL]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateCustomersNotification object:self];
                handler(nil);
            }
        } else {
            NSError * error = [[NSError alloc] init];
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
    return zdCustomer;
}

//更新储备客户
- (void)updateChanceCustomerWithCustomerInfoDictionary:(NSDictionary *)infoDictionary
                                            customerId:(NSString *)customerid
                                     completionHandler:(void(^)(NSError * error))handler
{
    [[ZDWebService sharedWebViewService] updatePotentialCustomerWithCustomerName:infoDictionary[@"customerName"] sex:infoDictionary[@"sex"] managerId:infoDictionary[@"managerId"] mobile:infoDictionary[@"mobile"] memo:infoDictionary[@"memo"] hope:infoDictionary[@"hope"] source:infoDictionary[@"source"] andCustomerId:customerid completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            //修改成功,存入coredata
            ZDCustomer * zdCustomer = [self manageZDCustomerFromInfoDictionary:infoDictionary andCustomerId:customerid];
            if ([[ZDLocalDB sharedLocalDB] saveCustomerWith:zdCustomer error:NULL]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZDUpdateCustomersNotification object:self];
                handler(nil);
            }
        } else {
            NSError * error = [[NSError alloc] init];
            handler(error);
        }
    }];
}

//删除储备客户
- (void)deleteChanceCustomerWithCustomerId:(NSString *)customerid
                         completionHandler:(void(^)(NSError * error))handler
{
    [[ZDWebService sharedWebViewService] deletePotentialCustomerWithCustomerId:customerid completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            //从数据库删除
        } else {
            NSError * error = [[NSError alloc] init];
            handler(error);
        }
    }];
}

#pragma mark - 客户所有联系记录
- (NSArray *)zdContactRecordsWithCustomerId:(NSString *)customerid
{
    return [[ZDLocalDB sharedLocalDB] queryZDContactRecordsWithCustomerId:customerid];
}

#pragma mark - properties

- (ZDManagerUser *)zdManagerUser
{
    if (!_zdManagerUser) {
        _zdManagerUser = [[ZDLocalDB sharedLocalDB] queryCurrentZDmanagerUser];
    }
    return _zdManagerUser;
}

- (NSArray *)allZDCustomers
{
    if (!_allZDCustomers) {
        _allZDCustomers = [[ZDLocalDB sharedLocalDB] queryAllZDCustomersOfCurrentManager];
    }
    return _allZDCustomers;
}

- (NSArray *)allZDChanceCustomers
{
    if (!_allZDChanceCustomers) {
        _allZDChanceCustomers = [[ZDLocalDB sharedLocalDB] queryAllZDChanceCustomersOfCurrentManager];
    }
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
