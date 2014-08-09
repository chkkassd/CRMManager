//
//  ZDLocalDB.h
//  CRMManager
//
//  Created by 施赛峰 on 14-8-9.
//  Copyright (c) 2014年 peter. All rights reserved.

//管理本地数据库类

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ZDCachePathUtility.h"

@interface ZDLocalDB : NSObject

+ (ZDLocalDB *)sharedLocalDB;

@end
