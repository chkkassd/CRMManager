//
//  ZDModeClient.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDModelClient.h"

@implementation ZDModelClient

//login
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSError *error))handler
{
    [[ZDWebService sharedWebViewService] loginWithUserName:userName password:password completionHandler:^(NSString *obj, NSError *error) {
        if (!error && [obj isEqualToString:@"0"]) {
            handler(nil);
        } else {
            error = error ? error : [[NSError alloc] init];
            handler(error);
        }
    }];
}

#pragma mark - sharedInstance

+ (ZDModelClient *)sharedModeClient
{
    static dispatch_once_t once;
    static ZDModelClient *sharedclient;
    dispatch_once(&once, ^{
        sharedclient = [[self alloc] init];
    });
    return sharedclient;
}

@end
