//
//  ZDModeClient.h
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDWebService.h"

@interface ZDModeClient : NSObject

//login
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSError *error))handler;

+ (ZDModeClient *)sharedModeClient;

@end
