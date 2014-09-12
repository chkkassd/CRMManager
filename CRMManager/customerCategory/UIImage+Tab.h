//
//  UIImage+Index.h
//  CRMManager
//
//  Created by apple on 14-8-13.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDModeClient.h"

@class ZDCustomer;
@interface UIImage (Tab)

+ (UIImage *)headImageForZDCustomer:(ZDCustomer *)zdCustomer
                           andIsBig:(BOOL)isBig;
@end
