//
//  ZDModeClient.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDModeClient.h"

@implementation ZDModeClient

//login
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSError *error))handler
{
    [[ZDWebService sharedWebViewService] loginWithUserName:userName password:password completionHandler:^(NSString *obj, NSError *error, NSString *count) {
        if (!error && [obj isEqualToString:@"0"]) {
            handler(nil);
        } else {
            error = error ? error : [[NSError alloc] init];
            handler(error);
        }
    }];
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
