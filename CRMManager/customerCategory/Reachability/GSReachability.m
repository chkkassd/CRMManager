//
//  GSReachability.m
//  GSMagazinePublish
//
//  Created by 蒋 宇 on 12-12-21.
//  Copyright (c) 2012年 zheng jie. All rights reserved.
//

#import "GSReachability.h"
#import "Reachability.h"

@implementation GSReachability

@synthesize reachability;

-(id) init {
    self = [super init];
    if (self) {
        self.reachability = [Reachability reachabilityForInternetConnection];
    }
    return self;
}

+(BOOL) enable3GorGRPS {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

+(BOOL) enableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

+(BOOL) checkIfOnline {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    switch (status) {
        case NotReachable:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络状态"
                                                            message:@"已断开网络"
                                                           delegate:nil
                                                  cancelButtonTitle:@"YES" otherButtonTitles:nil];
            [alert show];
        }
            break;
            
        case ReachableViaWiFi:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络状态"
                                                            message:@"您正在使用WiFi"
                                                           delegate:nil
                                                  cancelButtonTitle:@"YES" otherButtonTitles:nil];
            [alert show];
        }
            break;
            
        case ReachableViaWWAN:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络状态"
                                                            message:@"您正在使用3G/GPRS网络"
                                                           delegate:nil
                                                  cancelButtonTitle:@"YES" otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}


-(void) startNotification {
    //防止错误，先关闭持续检测
    [self cancelNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    [self.reachability performSelector:@selector(startNotifier)];
    self.enableNotification = YES;
}



-(void) cancelNotification {
    self.enableNotification = NO;
    [self.reachability performSelector:@selector(stopNotifier)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) dealloc {
    [self cancelNotification];
    self.reachability = nil;
}
@end
