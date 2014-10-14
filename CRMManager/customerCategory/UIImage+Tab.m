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
                         andIsEdite:(BOOL)isEdite
{
    if (!isBig) {
        //小头像
        if ([zdCustomer.sex isEqualToString:@"1"]) {
            return [UIImage imageNamed:@"ico_man_small.png"];
        } else if ([zdCustomer.sex isEqualToString:@"0"]) {
            return [UIImage imageNamed:@"ico_woman_small.png"];
        }
        return [UIImage imageNamed:@"ico_man_small.png"];
    } else if (!isEdite){
        //大头像,不可编辑
        if ([zdCustomer.sex isEqualToString:@"1"]) {
            return [UIImage imageNamed:@"ico_man_big.png"];
        } else if ([zdCustomer.sex isEqualToString:@"0"]) {
            return [UIImage imageNamed:@"ico_woman_big.png"];
        }
        return [UIImage imageNamed:@"ico_man_big.png"];
    } else {
        //大头像，可编辑
        if ([zdCustomer.sex isEqualToString:@"1"]) {
            return [UIImage imageNamed:@"ico_man_big_edit.png"];
        } else if ([zdCustomer.sex isEqualToString:@"0"]) {
            return [UIImage imageNamed:@"ico_woman_big_edit.png"];
        }
        return [UIImage imageNamed:@"ico_man_big_edit.png"];
    }
}
@end
