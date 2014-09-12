//
//  UIImage+Index.m
//  CRMManager
//
//  Created by apple on 14-8-13.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "UIImage+Tab.h"

@implementation UIImage (Tab)

+ (UIImage *)headImageForZDCustomer:(ZDCustomer *)zdCustomer
                           andIsBig:(BOOL)isBig
{
    if (!isBig) {
        //小头像
        if ([zdCustomer.sex isEqualToString:@"1"]) {
            return [UIImage imageNamed:@"ico_man_small.png"];
        } else if ([zdCustomer.sex isEqualToString:@"0"]) {
            return [UIImage imageNamed:@"ico_woman_small.png"];
        }
        return [UIImage imageNamed:@"ico_man_small.png"];
    } else {
        //大头像
        if ([zdCustomer.sex isEqualToString:@"1"]) {
            return [UIImage imageNamed:@"ico_man_big.png"];
        } else if ([zdCustomer.sex isEqualToString:@"0"]) {
            return [UIImage imageNamed:@"ico_woman_big.png"];
        }
        return [UIImage imageNamed:@"ico_man_big.png"];
    }
    
}
@end
