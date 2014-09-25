//
//  ZDCachePathUtility.m
//  CRMManager
//
//  Created by 施赛峰 on 14-8-9.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDCachePathUtility.h"

@implementation ZDCachePathUtility

#pragma mark - document or cache directory path

- (NSString *)pathForDocumentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSString *)pathForCacheDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

#pragma mark - path for sqlite

- (NSString *)pathForSqlite
{
    return [[self pathForCacheDirectory] stringByAppendingPathComponent:@"MySqlite.sqlite"];
}

#pragma mark - path for CRMState

- (NSString *)pathForCRMState
{
    return [[self pathForCacheDirectory] stringByAppendingPathComponent:@"CRMState.plist"];
}

#pragma mark - path for ForturnState

- (NSString *)pathForFortuneState
{
    return [[self pathForCacheDirectory] stringByAppendingPathComponent:@"FortuneState.plist"];
}

#pragma mark - sharedInstance

+ (ZDCachePathUtility *)sharedCachePathUtility
{
    static dispatch_once_t once;
    static ZDCachePathUtility *cacheUtility;
    dispatch_once(&once, ^{
        cacheUtility = [[self alloc] init];
    });
    return cacheUtility;
}

@end
