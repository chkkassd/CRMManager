//
//  ZDProductStore.h
//  CRMManager
//
//  Created by joseph on 9/5/14.
//  Copyright (c) 2014 peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDExhibitionStore : NSObject

@property (nonatomic, strong) NSArray* products;

+ (instancetype)sharedStore;

@end
