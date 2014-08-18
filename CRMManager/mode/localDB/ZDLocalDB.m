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

- (ContactRecord *)queryContactRecordWithRecordId:(NSString *)recordId
{
    ContactRecord * contactRecord = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ContactRecord"];
    request.predicate = [NSPredicate predicateWithFormat:@"recordId == %@", recordId];
    
    NSError *error = nil;
    NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResult.count) {
        contactRecord = fetchResult[0];
    } else {
        NSLog(@"fail to fetch managerUser from db:%@",error.localizedDescription);
    }
    return contactRecord;
}

- (ZDContactRecord *)queryZDContactRecordWithRecordId:(NSString *)recordId
{
    ContactRecord * contactRecord = [self queryContactRecordWithRecordId:recordId];
    if (contactRecord) {
        ZDContactRecord* zdContactRecord = [[ZDContactRecord alloc]init];
        [self modifyZDContactRecord:zdContactRecord from:contactRecord];
        return zdContactRecord;
    }
    return nil;
}

//查询某一个客户的所有联系记录,contactRecords
- (NSArray *)queryContactRecordsWithCustomerId:(NSString *)customerid
{
    Customer * customer = [self queryCustomerWithCustomerId:customerid];
    if (customer) {
        return [customer.allContactRecords allObjects];
    }
    return nil;
}

- (NSArray *)queryZDContactRecordsWithCustomerId:(NSString *)customerid
{
    NSArray * contactRecords = [self queryContactRecordsWithCustomerId:customerid];
    if (contactRecords) {
        NSMutableArray * zdContactRecords = [[NSMutableArray alloc] init];
        for (ContactRecord * contactRecord in contactRecords) {
            ZDContactRecord * zdContactRecord = [[ZDContactRecord alloc] init];
            [self modifyZDContactRecord:zdContactRecord from:contactRecord];
            [zdContactRecords addObject:zdContactRecord];
        }
        return zdContactRecords;
    }
    return nil;
}

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

- (ZDManagerUser *)queryCurrentZDmanagerUser
{
    if (!self.defaultCurrentUserId.length) return NO;
    
    ManagerUser *managerUser = [self queryManagerUserWithUserId:self.defaultCurrentUserId];
    if (managerUser) {
        ZDManagerUser * zdManagerUser = [[ZDManagerUser alloc] init];
        [self modifyZDManagerUser:zdManagerUser from:managerUser];
        return zdManagerUser;
    }
    return nil;
}

- (void)modifyZDContactRecord:(ZDContactRecord *)zdContactRecord from:(ContactRecord *)contactRecord
{
    zdContactRecord.recordId = contactRecord.recordId;
    zdContactRecord.contactType = contactRecord.contactType;
    zdContactRecord.contactNum = contactRecord.contactNum;
    zdContactRecord.content = contactRecord.content;
    zdContactRecord.hope = contactRecord.hope;
    zdContactRecord.contactTime = contactRecord.contactTime;
    zdContactRecord.managerId = contactRecord.managerId;
    zdContactRecord.customerId = contactRecord.customerId;
    zdContactRecord.inputId = contactRecord.inputId;
    zdContactRecord.memo = contactRecord.memo;
}

- (void)modifyZDManagerUser:(ZDManagerUser *)zdManager from:(ManagerUser *)managerUser
{
    zdManager.userid = managerUser.userid;
    zdManager.password = managerUser.password;
    zdManager.gesturePassword = managerUser.gesturePassword;
    zdManager.gesturePasswordSwitch = managerUser.gesturePasswordSwitch;
    zdManager.director = managerUser.director;
    zdManager.area = managerUser.area;
}

- (void)modifyZDCustomer:(ZDCustomer *)zdCustomer from:(Customer *)customer
{
    zdCustomer.customerId = customer.customerId;
    zdCustomer.customerName = customer.customerName;
    zdCustomer.idNum = customer.idNum;
    zdCustomer.mobile = customer.mobile;
    zdCustomer.cdHope = customer.cdHope;
    zdCustomer.date = customer.date;
    zdCustomer.customerType = customer.customerType;
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

//查找当前用户所有的customers
- (NSArray *)queryAllCustomersOfCurrentManager
{
    ManagerUser * managerUser = [self queryManagerUserWithUserId:self.defaultCurrentUserId];
    if (managerUser) {
        return [managerUser.allCustomers allObjects];
    }
    return nil;
}

//查找当前用户所有的ChanceCustomers
- (NSArray *)queryAllChanceCustomersOfCurrentManager
{
    NSArray * allCustomers = [self queryAllCustomersOfCurrentManager];
    if (allCustomers) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"customerType == %@",@"1"];
        NSArray * allChanceCustomers = [allCustomers filteredArrayUsingPredicate:predicate];
        return allChanceCustomers;
    }
    return nil;
}

- (NSArray *)queryAllZDChanceCustomersOfCurrentManager
{
    NSArray * allChanceCustomers = [self queryAllChanceCustomersOfCurrentManager];
    if (allChanceCustomers.count) {
        NSMutableArray * allZDChanceCustomers = [[NSMutableArray alloc] init];
        for (Customer * customer in allChanceCustomers) {
            ZDCustomer * zdCustomer = [[ZDCustomer alloc] init];
            [self modifyZDCustomer:zdCustomer from:customer];
            [allZDChanceCustomers addObject:zdCustomer];
        }
        return allZDChanceCustomers;
    }
    return nil;

}

- (NSArray *)queryAllZDCustomersOfCurrentManager
{
    NSArray * allCustomers = [self queryAllCustomersOfCurrentManager];
    if (allCustomers.count) {
        NSMutableArray * allZDCustomers = [[NSMutableArray alloc] init];
        for (Customer * customer in allCustomers) {
            ZDCustomer * zdCustomer = [[ZDCustomer alloc] init];
            [self modifyZDCustomer:zdCustomer from:customer];
            [allZDCustomers addObject:zdCustomer];
        }
        return allZDCustomers;
    }
    return nil;
}

#pragma mark - special for login to save managerUser,为了不影响本地手势密码的存储

//save managerUser for login
- (BOOL)loginSaveManagerUserWithZDManagerUser:(ZDManagerUser *)zdManager error:(NSError *__autoreleasing*)error
{
    if (!zdManager) return NO;
    
    ManagerUser *managerUser = [self queryManagerUserWithUserId:zdManager.userid];
    if (managerUser) {
        //存在，修改并保存
        [self loginModifyManagerUser:managerUser from:zdManager];
    } else {
        managerUser = [NSEntityDescription insertNewObjectForEntityForName:@"ManagerUser" inManagedObjectContext:self.managedObjectContext];
        [self loginModifyManagerUser:managerUser from:zdManager];
    }
    return [self.managedObjectContext save:error];
}

//translate zdManagerUser to managerUser for login
- (void)loginModifyManagerUser:(ManagerUser *)managerUser from:(ZDManagerUser *)zdManagerUser
{
    managerUser.userid = zdManagerUser.userid;
    managerUser.password = zdManagerUser.password;
    managerUser.director = zdManagerUser.director;
    managerUser.area = zdManagerUser.area;
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
    managerUser.gesturePasswordSwitch = zdManagerUser.gesturePasswordSwitch;
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

//save much contractrecords
- (BOOL)saveMuchContractRecordsWith:(NSArray *)contractRecords error:(NSError *__autoreleasing *)error
{
    if (!contractRecords.count) return NO;
    
    for (ZDContactRecord * zdContractRecord in contractRecords) {
        if (![self saveContactRecordWith:zdContractRecord error:error]) return NO;
    }
    return YES;
}

//save one contactrecord
- (BOOL)saveContactRecordWith:(ZDContactRecord *)zdContactRecord error:(NSError *__autoreleasing *)error
{
    if (!zdContactRecord) return NO;
    
    ContactRecord * contactRecord = [self queryContactRecordWithRecordId:zdContactRecord.recordId];
    if (contactRecord) {
        //存在，修改并保存
        [self modifyContactRecord:contactRecord from:zdContactRecord];
    } else {
        //不存在，插入一条
        contactRecord = [NSEntityDescription insertNewObjectForEntityForName:@"ContactRecord" inManagedObjectContext:self.managedObjectContext];
        [self modifyContactRecord:contactRecord from:zdContactRecord];
    }
    
    return [self.managedObjectContext save:error];
}

//translate zdContractReocrd to contractRecord
- (void)modifyContactRecord:(ContactRecord *)contractRecord from:(ZDContactRecord *)zdContractRecord
{
    contractRecord.recordId = zdContractRecord.recordId;
    contractRecord.contactType = zdContractRecord.contactType;
    contractRecord.contactNum = zdContractRecord.contactNum;
    contractRecord.content = zdContractRecord.content;
    contractRecord.hope = zdContractRecord.hope;
    contractRecord.contactTime = zdContractRecord.contactTime;
    contractRecord.managerId = zdContractRecord.managerId;
    contractRecord.customerId = zdContractRecord.customerId;
    contractRecord.inputId = zdContractRecord.inputId;
    contractRecord.memo = zdContractRecord.memo;
    contractRecord.recordBelongCustomer = [self queryCustomerWithCustomerId:zdContractRecord.customerId];
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
