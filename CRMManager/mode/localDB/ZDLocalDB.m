//
//  ZDLocalDB.m
//  CRMManager
//
//  Created by 施赛峰 on 14-8-9.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDLocalDB.h"

@interface ZDLocalDB()

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation ZDLocalDB

#pragma mark - coreData properties

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ZDModel" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)coordinator
{
    if (!_coordinator) {
        NSURL *storeURL = [NSURL fileURLWithPath:[[ZDCachePathUtility sharedCachePathUtility] pathForSqlite]];
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSError *error = nil;
        if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Fail to add persistent store: %@", error.localizedDescription);
        }
    }
    return _coordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:self.coordinator];
    }
    return _managedObjectContext;
}

#pragma mark - sharedInstance

+ (ZDLocalDB *)sharedLocalDB
{
    static dispatch_once_t once;
    static ZDLocalDB *localDB;
    dispatch_once(&once, ^{
        localDB = [[self alloc] init];
    });
    return localDB;
}

@end
