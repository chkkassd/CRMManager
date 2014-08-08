//
//  ZDWebService.h
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllCustomerCategoryHeaders.h"

@interface ZDWebService : NSObject

//登陆接口
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(NSString *obj,NSError *error))handler;
//单利
+(ZDWebService *)sharedWebViewService;

@end
