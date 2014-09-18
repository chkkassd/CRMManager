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
        NSLog(@"fail to fetch record from db:%@",error.localizedDescription);
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
    ManagerUser * managerUser = nil;
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
    if (!self.defaultCurrentUserId.length) return nil;
    
    ManagerUser * managerUser = [self queryManagerUserWithUserId:self.defaultCurrentUserId];
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
    zdManager.director = managerUser.director;
    zdManager.area = managerUser.area;
    zdManager.areaid = managerUser.areaid;
}

- (void)modifyZDCustomer:(ZDCustomer *)zdCustomer from:(Customer *)customer
{
    zdCustomer.customerId = customer.customerId;
    zdCustomer.customerName = customer.customerName;
    zdCustomer.idNum = customer.idNum;
    zdCustomer.mobile = customer.mobile;
    zdCustomer.cdHope = customer.cdHope;
    zdCustomer.sex = customer.sex;
    zdCustomer.memo = customer.memo;
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

- (ZDCustomer *)queryZDCustomerWithCustomerId:(NSString *)customerid
{
    Customer * customer = [self queryCustomerWithCustomerId:customerid];
    if (customer) {
        ZDCustomer * zdCustomer = [[ZDCustomer alloc] init];
        [self modifyZDCustomer:zdCustomer from:customer];
        return zdCustomer;
    }
    return nil;
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

//查找当前用户Zdcustomer类型的所有客户
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

//查找当前用户Zdcustomer类型的所有机会客户
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

//查找Zdcustomer类型的所有非储备客户
- (NSArray *)queryAllZDCurrentCustomersOfCurrentManager
{
    NSArray * allZDCustomers = [self queryAllZDCustomersOfCurrentManager];
    if (allZDCustomers) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"customerType != %@", @"1"];
        NSArray * allZDCurrentCustomers = [allZDCustomers filteredArrayUsingPredicate:predicate];
        return allZDCurrentCustomers;
    }
    return nil;
}

//查找business
- (Business *)queryBusinessWithCustomerId:(NSString *)customerid
{
    Customer * customer = [self queryCustomerWithCustomerId:customerid];
    if (customer) {
        if (customer.business) {
            return customer.business;
        }
        return nil;
    }
    return nil;
}

//查找businessList
- (BusinessList *)queryBusinessListWithCustomerId:(NSString *)customerid andLendingNo:(NSString *)lendingNo
{
    BusinessList * businessList = nil;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BusinessList"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"belongBusiness.businessBelongCustomer.customerId == %@ && lendingNo == %@",customerid,lendingNo];
    
    NSError * error = nil;
    NSArray * fetchResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchResult.count) {
        businessList = fetchResult[0];
    } else {
        NSLog(@"fail to fetch businessList of customer:%@ from db",customerid);
    }
    return businessList;
}

//查找一个客户的所有businessLists
- (NSArray *)queryAllBusinessListsWithCustomerId:(NSString *)customerid
{
    Business * business = [self queryBusinessWithCustomerId:customerid];
    if (business) {
        if ([[business.allBusinessLists allObjects] count]) {
            return [business.allBusinessLists allObjects];
        }
        return nil;
    }
    return nil;
}

//查找一个客户的所有ZDBusinessLists
- (NSArray *)queryAllZDBusinessListsWithCustomerId:(NSString *)customerid
{
    NSMutableArray * zdBusinessLists = [[NSMutableArray alloc] init];
    NSArray * businessLists = [self queryAllBusinessListsWithCustomerId:customerid];
    if (businessLists.count) {
        for (BusinessList * businessList in businessLists) {
            ZDBusinessList * zdBusinessList = [[ZDBusinessList alloc] init];
            [self modifyZDBusinessList:zdBusinessList fromBusinessList:businessList];
            [zdBusinessLists addObject:zdBusinessList];
        }
        return zdBusinessLists;
    }
    return nil;
}

- (void)modifyZDBusinessList:(ZDBusinessList *)zdBusinessList fromBusinessList:(BusinessList *)businessList
{
    zdBusinessList.customerId = businessList.belongBusiness.businessBelongCustomer.customerId;
    zdBusinessList.status = businessList.status;
    zdBusinessList.managementFeeDiscount = businessList.managementFeeDiscount;
    zdBusinessList.billDate = businessList.billDate;
    zdBusinessList.startDate = businessList.startDate;
    zdBusinessList.loanValue = businessList.loanValue;
    zdBusinessList.pattern = businessList.pattern;
    zdBusinessList.managementFeeRate = businessList.managementFeeRate;
    zdBusinessList.incomeTotal = businessList.incomeTotal;
    zdBusinessList.endDate = businessList.endDate;
    zdBusinessList.investAmt = businessList.investAmt;
    zdBusinessList.lendingNo = businessList.lendingNo ;
    zdBusinessList.contractNo = businessList.contractNo;
}

//查找一个birthRemind

- (BirthRemind *)queryBirthRemindWithCustomerId:(NSString *)customerId
{
    if (!customerId.length) return nil;
    
    BirthRemind * birthRemind = nil;
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"BirthRemind"];
    request.predicate = [NSPredicate predicateWithFormat:@"birthOfCustomer.customerId == %@",customerId];
    
    NSError * error = nil;
    NSArray * fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults.count) {
        birthRemind = fetchResults[0];
    } else {
        NSLog(@"fail to fetch birthRemind of customer:%@",customerId);
    }
    return birthRemind;
}

- (BirthRemind *)queryBirthRemindByRelationshipWithCustomerId:(NSString *)customerId
{
    Customer * customer = [self queryCustomerWithCustomerId:customerId];
    return customer.birthRemind;
}

//查找一个investmentRemind

- (InvestmentRemind *)queryInvestmentRemindWithCustomerId:(NSString *)customerId andFeLendNo:(NSString *)feLendNo
{
    if (!customerId.length || !feLendNo) return nil;
    
    InvestmentRemind * investmentRemind = nil;
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"InvestmentRemind"];
    request.predicate = [NSPredicate predicateWithFormat:@"investmentRemindOfCustomer.customerId == %@ && feLendNo == %@",customerId,feLendNo];
    
    NSError * error = nil;
    NSArray * fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults.count) {
        investmentRemind = fetchResults[0];
    } else {
        NSLog(@"fail to fetch investmentRemind of customer:%@",customerId);
    }
    return investmentRemind;
}

//查找一个客户的所有投资提醒

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
    managerUser.areaid = zdManagerUser.areaid;
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
    managerUser.areaid = zdManagerUser.areaid;
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
    customer.sex = zdCustomer.sex;
    customer.memo = zdCustomer.memo;
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

//save business
- (BOOL)saveBusinessWith:(ZDBusiness *)zdBusiness error:(NSError *__autoreleasing *)error
{
    if (!zdBusiness) return NO;
    
    Business * business = [self queryBusinessWithCustomerId:zdBusiness.customerId];
    if (business) {
        //存在，修改并保存
        [self modifyBusiness:business from:zdBusiness];
    } else {
        //不存在，插入一条
        business = [NSEntityDescription insertNewObjectForEntityForName:@"Business" inManagedObjectContext:self.managedObjectContext];
        [self modifyBusiness:business from:zdBusiness];
    }
    return [self.managedObjectContext save:error];
}

- (void)modifyBusiness:(Business *)business from:(ZDBusiness *)zdBusiness
{
    business.incomeTotal = zdBusiness.incomeTotal;
    business.customerName = zdBusiness.customerName;
    business.applyDate = zdBusiness.applyDate;
    business.productType = zdBusiness.productType;
    business.accountTotal = zdBusiness.accountTotal;
    business.recoverableAmount = zdBusiness.recoverableAmount;
    business.businessBelongCustomer = [self queryCustomerWithCustomerId:zdBusiness.customerId];
}

//save one businessList
- (BOOL)saveBusinessList:(ZDBusinessList *)zdBusinessList error:(NSError *__autoreleasing *)error
{
    if (!zdBusinessList) return NO;
    
    BusinessList * businessList = [self queryBusinessListWithCustomerId:zdBusinessList.customerId andLendingNo:zdBusinessList.lendingNo];
    if (businessList) {
        // 存在，修改并保存
        [self modifyBusinessList:businessList from:zdBusinessList];
    } else {
        // 不存在，插入一条
        businessList = [NSEntityDescription insertNewObjectForEntityForName:@"BusinessList" inManagedObjectContext:self.managedObjectContext];
        [self modifyBusinessList:businessList from:zdBusinessList];
    }
    
    return [self.managedObjectContext save:error];
}

- (void)modifyBusinessList:(BusinessList *)businessList from:(ZDBusinessList *)zdBusinessList
{
    businessList.status = zdBusinessList.status;
    businessList.managementFeeDiscount = zdBusinessList.managementFeeDiscount;
    businessList.billDate = zdBusinessList.billDate;
    businessList.startDate = zdBusinessList.startDate;
    businessList.loanValue = zdBusinessList.loanValue;
    businessList.pattern = zdBusinessList.pattern;
    businessList.managementFeeRate = zdBusinessList.managementFeeRate;
    businessList.incomeTotal = zdBusinessList.incomeTotal;
    businessList.endDate = zdBusinessList.endDate;
    businessList.investAmt = zdBusinessList.investAmt;
    businessList.lendingNo = zdBusinessList.lendingNo ;
    businessList.contractNo = zdBusinessList.contractNo;
    businessList.belongBusiness = [self queryBusinessWithCustomerId:zdBusinessList.customerId];
}

// Save much businessLists
- (BOOL)saveMuchBusinessList:(NSArray *)zdBusinessLists error:(NSError *__autoreleasing *)error
{
    if (!zdBusinessLists.count) return NO;
    
    for (ZDBusinessList * zdBusinessList in zdBusinessLists) {
        if (![self saveBusinessList:zdBusinessList error:error]) return NO;
    }
    return YES;
}

//save one birthRemind
- (BOOL)saveBirthRemind:(ZDBirthRemind *)zdBirthRemind error:(NSError *__autoreleasing *)error
{
    if (!zdBirthRemind) return NO;
    
    BirthRemind * birthRemind = [self queryBirthRemindWithCustomerId:zdBirthRemind.customerId];
    
    if (birthRemind) {
        //存在，修改并保存
        [self modifyBirthRemind:birthRemind from:zdBirthRemind];
    }else {
        //不存在，插入一条
        birthRemind = [NSEntityDescription insertNewObjectForEntityForName:@"BirthRemind" inManagedObjectContext:self.managedObjectContext];
        [self modifyBirthRemind:birthRemind from:zdBirthRemind];
    }
    return [self.managedObjectContext save:error];
}

- (void)modifyBirthRemind:(BirthRemind *)birthRemind from:(ZDBirthRemind *)zdBirthRemind
{
    birthRemind.dataOfBirth = zdBirthRemind.dateOfBirth;
    birthRemind.birthOfCustomer = [self queryCustomerWithCustomerId:zdBirthRemind.customerId];
}

//save much birthReminds
- (BOOL)saveBirthReminds:(NSArray *)zdBirthReminds error:(NSError *__autoreleasing *)error
{
    if (!zdBirthReminds.count) return NO;
    
    for (ZDBirthRemind * zdBirthRemind in zdBirthReminds) {
        if (![self saveBirthRemind:zdBirthRemind error:error]) return NO;
    }
    return YES;
}

//save one investmentRemind
- (BOOL)saveInvestmentRemind:(ZDInvestmentRemind *)zdInvestmentRemind error:(NSError *__autoreleasing *)error
{
    if (!zdInvestmentRemind) return NO;
    
    InvestmentRemind * investmentRemind = [self queryInvestmentRemindWithCustomerId:zdInvestmentRemind.customerId andFeLendNo:zdInvestmentRemind.feLendNo];
    
    if (investmentRemind) {
        //存在，修改并保存
        [self modifyInvestmentRemind:investmentRemind from:zdInvestmentRemind];
    } else {
        //不存在，插入一条
        investmentRemind = [NSEntityDescription insertNewObjectForEntityForName:@"InvestmentRemind" inManagedObjectContext:self.managedObjectContext];
        [self modifyInvestmentRemind:investmentRemind from:zdInvestmentRemind];
    }
    return [self.managedObjectContext save:error];
}

- (void)modifyInvestmentRemind:(InvestmentRemind *)investmentRemind from:(ZDInvestmentRemind *)zdInvestmentRemind
{
    investmentRemind.feLendNo = zdInvestmentRemind.feLendNo;
    investmentRemind.investAmt = zdInvestmentRemind.investAmt;
    investmentRemind.endDate = zdInvestmentRemind.endDate;
    investmentRemind.pattern = zdInvestmentRemind.pattern;
    investmentRemind.investmentRemindOfCustomer = [self queryCustomerWithCustomerId:zdInvestmentRemind.customerId];
}

//save much investmentReminds

- (BOOL)saveInvestmentReminds:(NSArray *)zdInvestmentReminds error:(NSError *__autoreleasing *)error
{
    if (!zdInvestmentReminds.count) return NO;
    
    for (ZDInvestmentRemind * zdInvestmentRemind in zdInvestmentReminds) {
        if (![self saveInvestmentRemind:zdInvestmentRemind error:error]) return NO;
    }
    return YES;
}

#pragma mark - delete

//delete one customer
- (BOOL)deleteOneCustomerWithCustomerId:(NSString *)customerid error:(NSError **)error
{
    Customer * customer = [self queryCustomerWithCustomerId:customerid];
    if (customer) {
        [self.managedObjectContext deleteObject:customer];
        return [self.managedObjectContext save:error];
    }
    return NO;
}

//delete one record
- (BOOL)deleteOneContactRecordWithReocrdId:(NSString *)recordid error:(NSError **)error
{
    ContactRecord * contactRecord = [self queryContactRecordWithRecordId:recordid];
    if (contactRecord) {
        [self.managedObjectContext deleteObject:contactRecord];
        return [self.managedObjectContext save:error];
    }
    return NO;
}

//delete managerUser
- (BOOL)deleteManagerUserWithUserId:(NSString *)userid error:(NSError *__autoreleasing *)error
{
    ManagerUser * managerUser = [self queryManagerUserWithUserId:userid];
    if (managerUser) {
        [self.managedObjectContext deleteObject:managerUser];
        return [self.managedObjectContext save:error];
    }
    return YES;
}

#pragma mark - coreData properties

- (NSString *)defaultCurrentUserId
{
    _defaultCurrentUserId = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultCurrentUserId];
    
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
