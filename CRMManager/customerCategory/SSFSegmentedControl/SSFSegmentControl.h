//
//  SSFSegmentControl.h
//  SegmentControlDemo
//
//  Created by 施赛峰 on 14-8-17.
//  Copyright (c) 2014年 赛峰 施. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSFSegmentControlDelegate;

@interface SSFSegmentControl : UIView

@property (nonatomic) NSInteger selectedIndex;
@property (weak, nonatomic) id <SSFSegmentControlDelegate> delegate;

//根据nib初始化view
+(SSFSegmentControl *)SSFSegmentedControlInstance;

@end

@protocol SSFSegmentControlDelegate <NSObject>

- (void)SSFSegmentControlDidPressed:(UIView *)view selectedIndex:(NSInteger)selectedIndex;

@end