//
//  ZDLocalDB.m
//  CRMManager
//
//  Created by 施赛峰 on 14-8-9.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDLocalDB.h"

@interface ZDLocalDB()

@property (strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator * coordinator;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSString * defaultCurrentUserId;

@end

@implementation ZDLocalDB

#pragma mark - query

- (ManagerUser *)queryManagerUserWithUserId:(NSString *)userid
{
    ManagerUser *managerUser = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ManagerUser"];
    request.predicate = [NSPredicate predicateWithFormat:@"userid == %@",userid];
    
    NSError *error = nil;
    NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResult.count) {
        managerUser = fetchResult[0];
    } else {
        NSLog(@"fail to fetch managerUser from db:%@",error.localizedDescription);
    }
    return managerUser;
}

- (Customer *)queryCustomerWithCustomerId:(NSString *)customerid
{
    Customer *customer = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Customer"];
    request.predicate = [NSPredicate predicateWithFormat:@"customerId == %@ && belongManager.userid == %@",customerid,self.defaultCurrentUserId];
    
    NSError * error = nil;
    NSArray * fetchResult = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResult.count) {
        customer = fetchResult[0];
    } else {
        NSLog(@"fail to fetch customer from db:%@",error.localizedDescription);
    }
    return customer;
}

#pragma mark - modify and save

//save managerUser
- (BOOL)saveManagerUserWithZDManagerUser:(ZDManagerUser *)zdManager error:(NSError *__autoreleasing*)error
{
    if (!zdManager) return NO;
    
    ManagerUser *managerUser = [self queryManagerUserWithUserId:zdManager.userid];
    if (managerUser) {
        //存在，修改并保存
        [self modifyManagerUser:managerUser from:zdManager];
    } else {
        managerUser = [NSEntityDescription insertNewObjectForEntityForName:@"ManagerUser" inManagedObjectContext:self.managedObjectContext];
        [self modifyManagerUser:managerUser from:zdManager];
    }
    return [self.managedObjectContext save:error];
}

//translate zdManagerUser to managerUser
- (void)modifyManagerUser:(ManagerUser *)managerUser from:(ZDManagerUser *)zdManagerUser
{
    managerUser.userid = zdManagerUser.userid;
    managerUser.password = zdManagerUser.password;
    managerUser.gesturePassword = zdManagerUser.gesturePassword;
    managerUser.director = zdManagerUser.director;
    managerUser.area = zdManagerUser.area;
}

//save much customers
- (BOOL)saveMuchCustomersWith:(NSArray *)customers error:(NSError *__autoreleasing*)error
{
    if (!customers.count) return NO;
    
    for (ZDCustomer *zdCustomer in customers) {
        if (![self saveCustomerWith:zdCustomer error:error]) return NO;
    }
    return YES;
}

//save one customer
- (BOOL)saveCustomerWith:(ZDCustomer *)zdCustomer error:(NSError *__autoreleasing *)error
{
    if (!zdCustomer) return NO;
    
    Customer * customer = [self queryCustomerWithCustomerId:zdCustomer.customerId];
    if (customer) {
        //存在，修改并保存
        [self modifyCustomer:customer from:zdCustomer];
    } else {
        //不存在，插入一条
        customer = [NSEntityDescription insertNewObjectForEntityForName:@"Customer" inManagedObjectContext:self.managedObjectContext];
        [self modifyCustomer:customer from:zdCustomer];
    }
    
    return [self.managedObjectContext save:error];
}

//translate zdcustomer to customer
- (void)modifyCustomer:(Customer *)customer from:(ZDCustomer *)zdCustomer
{
    customer.customerId = zdCustomer.customerId;
    customer.customerName = zdCustomer.customerName;
    customer.idNum = zdCustomer.idNum;
    customer.mobile = zdCustomer.mobile;
    customer.cdHope = zdCustomer.cdHope;
    customer.date = zdCustomer.date;
    customer.customerType = zdCustomer.customerType;
    customer.belongManager = [self queryManagerUserWithUserId:self.defaultCurrentUserId];
}

#pragma mark - coreData properties

- (NSString *)defaultCurrentUserId
{
    if (!_defaultCurrentUserId) {
        _defaultCurrentUserId = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultCurrentUserId];
    }
    return _defaultCurrentUserId;
}

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
