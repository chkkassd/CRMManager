//
//  ZDCachePathUtility.h
//  CRMManager
//
//  Created by 施赛峰 on 14-8-9.
//  Copyright (c) 2014年 peter. All rights reserved.

//管理缓存数据的所有路径

#import <Foundation/Foundation.h>

@interface ZDCachePathUtility : NSObject

- (NSString *)pathForSqlite;
- (NSString *)pathForCRMState;
- (NSString *)pathForFortuneState;
+ (ZDCachePathUtility *)sharedCachePathUtility;

@end
