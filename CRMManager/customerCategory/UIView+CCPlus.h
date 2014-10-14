//
//  UIView+CCPlus.h
//  YOUSHIiPhone
//
//  Created by Ken on 14-5-9.
//  Copyright (c) 2014年 Derek ZHOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CCPlus)

+ (BOOL)resignFirstResponder:(UIView *)aView;

+ (void)configureSeparatorLinesFromOutletCollections:(NSArray *)collections
                                     withBorderWidth:(CGFloat)borderWidth
                                     withBorderColor:(UIColor *)color;

+ (void)configureRoundedBorderView:(UIView *)aView
                   withBorderWidth:(CGFloat)borderWidth
                   withBorderColor:(UIColor *)color
                  withCornerRadius:(CGFloat)cornerRadius;
@end
