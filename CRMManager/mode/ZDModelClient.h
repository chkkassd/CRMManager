//
//  ZDModeClient.h
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDWebService.h"


// 这个类，貌似也不应该过于庞大，回家想想
@interface ZDModelClient : NSObject

//login
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSError *error))handler;

+ (ZDModelClient *)sharedModeClient;

@end
