//
//  ZDTabBarStore.m
//  CRMManager
//
//  Created by joseph on 9/5/14.
//  Copyright (c) 2014 peter. All rights reserved.
//

#import "ZDTabBarStore.h"

@implementation ZDTabBarStore

- (NSArray *)highlightedIcons
{
    if (!_highlightedIcons) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"tabBar" ofType:@"plist"];
        _highlightedIcons = [NSArray arrayWithContentsOfFile:path];
    }
    return _highlightedIcons;
}



+ (instancetype)sharedStore
{
    static ZDTabBarStore* sharedStore;
    
    if (!sharedStore) {
        sharedStore = [ZDTabBarStore new];
    }
    
    return sharedStore;
}

@end
