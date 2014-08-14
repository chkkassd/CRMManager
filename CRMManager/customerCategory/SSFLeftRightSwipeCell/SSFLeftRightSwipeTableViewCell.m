//
//  SSFLeftRightSwipeTableViewCell.m
//  TableViewCellDemo
//
//  Created by 施赛峰 on 14-7-23.
//  Copyright (c) 2014年 赛峰 施. All rights reserved.
//

#import "SSFLeftRightSwipeTableViewCell.h"

@interface SSFLeftRightSwipeTableViewCell()

@property (nonatomic) CGPoint originalCenterPoint;
@property (nonatomic) CGFloat xDistance;

@end

@implementation SSFLeftRightSwipeTableViewCell

- (void)awakeFromNib
{
    self.isEditMode = NO;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.realContentView addGestureRecognizer:pan];
}

#pragma mark - methods
- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.deleteButton.hidden = NO;
        self.editeButton.hidden = NO;
        self.originalCenterPoint = self.contentView.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint newPoint = [sender translationInView:self.contentView];
        
        if (self.realContentView.center.x <= self.contentView.center.x) {
            self.realContentView.center = CGPointMake(self.realContentView.center.x + newPoint.x, self.realContentView.center.y);
            self.xDistance = self.realContentView.center.x - self.originalCenterPoint.x;
        }
        
        [sender setTranslation:CGPointMake(0, 0) inView:self.contentView];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        /*
        if (self.xDistance >= 40) {
            [UIView animateWithDuration:0.3 animations:^{
                self.realContentView.center = CGPointMake(self.originalCenterPoint.x + 59, self.originalCenterPoint.y);
            } completion:^(BOOL finished) {
                self.isEditMode = YES;
            }];
        } else 
         */
         if (self.xDistance <= -40) {
            [UIView animateWithDuration:0.3 animations:^{
                self.realContentView.center = CGPointMake(self.originalCenterPoint.x - self.deleteButton.frame.size.width - self.editeButton.frame.size.width, self.originalCenterPoint.y);
            } completion:^(BOOL finished) {
                self.isEditMode = YES;
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                self.realContentView.center = CGPointMake(self.originalCenterPoint.x , self.originalCenterPoint.y);
            } completion:^(BOOL finished) {
                if (finished) {
                    self.isEditMode = NO;
                    self.deleteButton.hidden = YES;
                    self.editeButton.hidden = YES;
                }
            }];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        if (self.isEditMode) {
            [UIView animateWithDuration:0.3 animations:^{
                self.realContentView.center = CGPointMake(self.originalCenterPoint.x , self.originalCenterPoint.y);
            } completion:^(BOOL finished) {
                if (finished) {
                    self.isEditMode = NO;
                }
            }];
        }
    }
}

#pragma mark - action
- (IBAction)deleteButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(leftRightSwipeTableViewCellDeleteButtonPressed:)]) {
        [self.delegate leftRightSwipeTableViewCellDeleteButtonPressed:self];
    }
}

- (IBAction)editeButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(leftRightSwipeTableViewCellEditeButtonPressed:)]) {
        [self.delegate leftRightSwipeTableViewCellEditeButtonPressed:self];
    }
}

#pragma mark - sharedInstance
+ (SSFLeftRightSwipeTableViewCell *)instanceSSFLeftRightSwipeTableViewCell
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"SSFLeftRightSwipeTableViewCell" owner:self options:nil];
    return arr[0];
}

@end
