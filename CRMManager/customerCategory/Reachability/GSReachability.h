//
//  GSReachability.h
//  GSMagazinePublish
//
//  Created by 蒋 宇 on 12-12-21.
//  Copyright (c) 2012年 zheng jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;

@interface GSReachability : NSObject

@property (strong, nonatomic) Reachability *reachability;
@property (assign) BOOL enableNotification;     //是否已打开持续检测

//开始持续检测
-(void) startNotification;

//关闭持续检测
-(void) cancelNotification;

//是否支持3G/GPRS
+(BOOL) enable3GorGRPS;

//是否支持WIFI
+(BOOL) enableWIFI;

//检测当前是否联网
+(BOOL) checkIfOnline;

@end
