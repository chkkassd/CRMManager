//
//  ZDWebService.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDWebService.h"
#import "ZDWebService+URL.h"

@implementation ZDWebService

//登录接口
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSString *state,NSError *error, NSString *count))handler
{
    password = [NSString md5:password];
    NSDictionary *dict = @{
                           @"userName":userName,
                           @"password":password
                           };
    NSURL *url = [self URLForLogin];
    [self fetchByWebservice:url dict:dict handler:handler];
}

//根据用户id得到所有的customers的总数量
- (void)fetchCustomersCountWithManagerUserId:(NSString *)userid completionHandler:(void(^)(NSString *state,NSError *error,NSString *count))handler
{
    NSDictionary *dict = @{
                           @"id":userid
                           };
    NSURL *url = [self URLForGetCustomersCount];
    [self fetchByWebservice:url dict:dict handler:handler];
}

//根据用户id得到所有的customers
- (void)fetchCustomersWithManagerUserId:(NSString *)userid completionHandler:(void(^)(NSString *state,NSError *error,NSString *count))handler
{
    NSDictionary *dic = @{
                          @"pageNo":@"1",
                          @"pageSize":@"100",
                          @"id":userid
                          };
    NSURL *url = [self URLForGetAllCustomers];
    [self fetchByWebservice:url dict:dic handler:handler];
}


// 稳定的网络访问webservice的接口
- (void)fetchByWebservice:(NSURL *)url dict:(NSDictionary *)dict handler:(void (^)(NSString *, NSError *, NSString *))handler
{
    NSString *jsonString = [self translateToJsonStringWithDictionary:dict];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonString length]];
    
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req addValue:@"" forHTTPHeaderField:@"netmac"];//客户端网卡mac值
    [req addValue:@"" forHTTPHeaderField:@"version"];//手机端应用版本号
    [req addValue:@"" forHTTPHeaderField:@"token"];//ios提交
    [req addValue:@"" forHTTPHeaderField:@"User-Agent"];//1.系统的名称如： iPhone OS，Android 2.设备系统的版本号；如： 5.1、6.0、7.0 3.设备的型号 如：iPad、iphone、ipod touch
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //ios5之后新增异步发送接口，无需再调用connectiondelegate
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            //解析得到的json数据
            NSError *error = nil;
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"%@",responseDic);
            if (responseDic) {
                handler(responseDic[@"status"],nil,responseDic[@"count"]);
            } else {
                handler(@"-1",nil,@"0");
            }
        } else {
            NSLog(@"Http error:%@", connectionError.localizedDescription);
            handler(@"-1",connectionError,@"0");
        }
    }];
}


#pragma mark - translateToJsonString

- (NSString *)translateToJsonStringWithDictionary:(NSDictionary *)dic
{
    NSArray *keys = [dic allKeys];
    NSArray *values = [dic allValues];
    NSString *jsonString = @"json={";
    for (int i = 0; i < keys.count; i ++) {
        if (i != (keys.count - 1)) {
            jsonString = [jsonString stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\",",keys[i],values[i]]];
        } else {
            jsonString = [jsonString stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",keys[i],values[i]]];
        }
    }
    jsonString = [jsonString stringByAppendingString:@"}"];
    return jsonString;
}

#pragma mark - sharedInstance

+ (ZDWebService *)sharedWebViewService
{
    static dispatch_once_t once;
    static ZDWebService *sharedWebService;
    dispatch_once(&once, ^{
        sharedWebService = [[self alloc] init];
    });
    return sharedWebService;
}

@end
