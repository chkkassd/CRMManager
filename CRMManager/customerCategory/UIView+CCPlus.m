//
//  UIView+CCPlus.m
//  YOUSHIiPhone
//
//  Created by Ken on 14-5-9.
//  Copyright (c) 2014年 Derek ZHOU. All rights reserved.
//

#import "UIView+CCPlus.h"

@implementation UIView (CCPlus)

+ (BOOL)resignFirstResponder:(UIView *)aView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:aView action:@selector(tapView:)];
    [aView addGestureRecognizer:tap];
    return YES;
}

- (void)tapView:(UITapGestureRecognizer *)sender {
    NSLog(@"resignFirstResponder");
    UIView *view = sender.view;
    [view endEditing:YES];
}

+ (void)configureSeparatorLinesFromOutletCollections:(NSArray *)collections
                                     withBorderWidth:(CGFloat)borderWidth
                                     withBorderColor:(UIColor *)color {
    
    for (int i = 0; i < [collections count]; i++) {
        if ([collections[i] isKindOfClass:[UIView class]]) {
            UIView *separator = collections[i];
            separator.backgroundColor = [UIColor clearColor];
            separator.layer.borderWidth = borderWidth;
            separator.layer.borderColor = color.CGColor;
            [separator setClipsToBounds:YES];
        }
    }
}

+ (void)configureRoundedBorderView:(UIView *)aView
                              withBorderWidth:(CGFloat)borderWidth
                              withBorderColor:(UIColor *)color
                              withCornerRadius:(CGFloat)cornerRadius {
    
    aView.layer.borderColor = color.CGColor;
    aView.layer.borderWidth = borderWidth;
    aView.layer.cornerRadius = cornerRadius;
    [aView setClipsToBounds:YES];
}

@end
