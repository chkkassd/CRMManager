//
//  UIImage+Index.m
//  CRMManager
//
//  Created by apple on 14-8-13.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "UIImage+Tab.h"

@implementation UIImage (Tab)

+ (UIImage *)imageWithIndex:(int)index
{
    static NSDictionary* tarItems;
    if (!tarItems) {
        tarItems = @{
                     @"Tab_Bar_Item_0": @"main_ico_footer_chance_pressed",
                     @"Tab_Bar_Item_1": @"main_ico_footer_client_pressed",
                     @"Tab_Bar_Item_2": @"main_ico_footer_product_pressed",
                     @"Tab_Bar_Item_3": @"maini_ico_footer_setting_pressed",
                     };
    }
    NSString* key = [NSString stringWithFormat:@"Tab_Bar_Item_%d", index];
    return [UIImage imageNamed:tarItems[key]];
}

@end
