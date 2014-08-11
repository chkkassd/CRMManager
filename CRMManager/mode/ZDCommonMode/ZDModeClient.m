//
//  ZDModeClient.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDModeClient.h"

@implementation ZDModeClient

#pragma mark - login and fetch data

//login and save all data
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSError *error))handler
{
    ZDManagerUser * managerUser = [[ZDManagerUser alloc] init];
    
    [[ZDWebService sharedWebViewService] loginWithUserName:userName password:password completionHandler:^(NSError *error, NSDictionary *resultDic) {
        if (!error) {
            //1.保存当前登录账号的userid
            [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"id"] forKey:DefaultCurrentUserId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //2.保存当前用户(managerUser)信息
            managerUser.userid = resultDic[@"id"];
            managerUser.password = password;
            if ([[ZDLocalDB sharedLocalDB] loginSaveManagerUserWithZDManagerUser:managerUser error:NULL]) {
                //3.获取并保存客户信息
                [self fetchAndSaveCustomersWithManagerUserId:managerUser.userid completionHandler:^(NSError *error) {
                    if (!error) {
                        handler(nil);//未完整，待续。。
                    } else {
                        NSError * error = [[NSError alloc] init];
                        handler(error);
                    }
                }];
            } else {
                NSError * error = [[NSError alloc] init];
                handler(error);
            }
            handler(nil);
        } else {
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
                //save success
                handler(nil);
            } else {
                //save fail
                NSError * error = [[NSError alloc] init];
                handler(error);
            }
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

#pragma mark - properties

- (ZDManagerUser *)zdManagerUser
{
    if (!_zdManagerUser) {
        _zdManagerUser = [[ZDLocalDB sharedLocalDB] queryCurrentZDmanagerUser];
    }
    return _zdManagerUser;
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
