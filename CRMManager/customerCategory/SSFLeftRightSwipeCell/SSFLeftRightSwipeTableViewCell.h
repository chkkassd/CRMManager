//
//  SSFLeftRightSwipeTableViewCell.h
//  TableViewCellDemo
//
//  Created by 施赛峰 on 14-7-23.
//  Copyright (c) 2014年 赛峰 施. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSFLeftRightSwipeTableViewCellDelegate;

@interface SSFLeftRightSwipeTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *editeButton;
@property (weak, nonatomic) IBOutlet UIView *realContentView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel * interestLabel;
@property (weak, nonatomic) IBOutlet UIImageView * headImageView;
@property (weak, nonatomic) IBOutlet UIImageView * alertImageView;
@property (nonatomic) BOOL isEditMode;
@property (nonatomic) BOOL startGesture;//yes,手势开启，no，手势关闭
@property (weak, nonatomic) id <SSFLeftRightSwipeTableViewCellDelegate> delegate;

+ (SSFLeftRightSwipeTableViewCell *)instanceSSFLeftRightSwipeTableViewCell;//根据xib创建cell
@end

@protocol SSFLeftRightSwipeTableViewCellDelegate <NSObject>

- (void)leftRightSwipeTableViewCellDeleteButtonPressed:(SSFLeftRightSwipeTableViewCell *)cell;
- (void)leftRightSwipeTableViewCellEditeButtonPressed:(SSFLeftRightSwipeTableViewCell *)cell;
- (void)leftRightSwipeTableViewCellTelephoneButtonPressed:(SSFLeftRightSwipeTableViewCell *)cell;

@end