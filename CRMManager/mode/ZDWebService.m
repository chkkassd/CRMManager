//
//  ZDWebService.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDWebService.h"
#define API_LoginURL @"https://api.ezendai.com/hera/manageraccount/login"   //login
#define API_GetAllCustomersURL @"https://api.ezendai.com/hera/manageraccount/getCustomers" //getAllCustomers

@implementation ZDWebService

//登录接口
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSString *obj,NSError *error))handler
{
    password = [NSString md5:password];
    NSDictionary *dic = @{@"userName":userName,@"password":password};
    NSString *jsonString = [self translateToJsonStringWithDictionary:dic];
    
    NSURL *url = [NSURL URLWithString: API_LoginURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonString length]];
    
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //ios5之后新增异步发送接口，无需再调用connectiondelegate
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            //http code
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSLog(@"Http code %ld",(long)responseCode);
            //解析得到的json数据
            NSError *error = nil;
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"%@",responseDic);
            if (responseDic) {
                handler(responseDic[@"status"],nil);
            } else {
                handler(@"-1",nil);
            }
        } else {
            NSLog(@"Http error:%@", connectionError.localizedDescription);
            handler(@"-1",connectionError);
        }
    }];
}

//根据用户id得到所有的customers

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

+(ZDWebService *)sharedWebViewService
{
    static dispatch_once_t once;
    static ZDWebService *sharedWebService;
    dispatch_once(&once, ^{
        sharedWebService = [[self alloc] init];
    });
    return sharedWebService;
}

@end
