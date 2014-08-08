//
//  ZDModeClient.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDModelFacade.h"

@implementation ZDModelFacade

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

+ (ZDModelFacade *)sharedModeClient
{
    static dispatch_once_t once;
    static ZDModelFacade *sharedclient;
    dispatch_once(&once, ^{
        sharedclient = [[self alloc] init];
    });
    return sharedclient;
}

@end
