//
//  SSFPathLineLayer.m
//  RecoginizerPasswordDemo
//
//  Created by 施赛峰 on 14-7-21.
//  Copyright (c) 2014年 赛峰 施. All rights reserved.
//

#import "SSFPathLineLayer.h"
#import <QuartzCore/QuartzCore.h>

@implementation SSFPathLineLayer

- (void)drawInContext:(CGContextRef)ctx
{
    //指定直线样式
    CGContextSetLineCap(ctx,kCGLineCapSquare);
    
    //直线宽度
    CGContextSetLineWidth(ctx,5.0);
    
    //设置颜色
    CGContextSetRGBStrokeColor(ctx,45/255.0, 99/255.0, 137/255.0, 0.5);
    
    //设置连接线拐角
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    //开始绘制
    CGContextBeginPath(ctx);
    
    //路径起点
    CGContextMoveToPoint(ctx,self.passwordGestureView.startPoint.x, self.passwordGestureView.startPoint.y);
    
    //如果有已经链接的点，先绘制已经被选的点
    if (self.passwordGestureView.selectedButtons.count) {
        for (int i = 0; i < self.passwordGestureView.selectedButtons.count; i++) {
            UIButton *button = self.passwordGestureView.selectedButtons[i];
            CGContextAddLineToPoint(ctx, button.center.x, button.center.y);
        }
    }
    
    //最后的点
    CGContextAddLineToPoint(ctx,self.passwordGestureView.endPoint.x, self.passwordGestureView.endPoint.y);
    
    //绘制完成
    CGContextDrawPath(ctx, kCGPathStroke);
}

@end
