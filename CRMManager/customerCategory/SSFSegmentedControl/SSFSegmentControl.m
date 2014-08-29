//
//  SSFSegmentControl.m
//  SegmentControlDemo
//
//  Created by 施赛峰 on 14-8-17.
//  Copyright (c) 2014年 赛峰 施. All rights reserved.
//

#import "SSFSegmentControl.h"
@interface SSFSegmentControl()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray * items;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray * labels;

@end

@implementation SSFSegmentControl

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.selectedIndex = 0;
        
    }
    return self;
}

#pragma mark - Action

- (IBAction)firstSegmentPressed:(UIButton *)sender
{
    self.selectedIndex = 0;
    [self updateSegmentViewForSelectedIndex:self.selectedIndex andButton:sender];
    
    [self.delegate SSFSegmentControlDidPressed:self selectedIndex:self.selectedIndex];
}

- (IBAction)secondSegmentPressed:(UIButton *)sender
{
    self.selectedIndex = 1;
    [self updateSegmentViewForSelectedIndex:self.selectedIndex andButton:sender];

    [self.delegate SSFSegmentControlDidPressed:self selectedIndex:self.selectedIndex];
}

- (IBAction)thirdSegmentPressed:(UIButton *)sender
{
    self.selectedIndex = 2;
    [self updateSegmentViewForSelectedIndex:self.selectedIndex andButton:sender];

    [self.delegate SSFSegmentControlDidPressed:self selectedIndex:self.selectedIndex];
}

- (IBAction)fourthSegmentPressed:(UIButton *)sender
{
    self.selectedIndex = 3;
    [self updateSegmentViewForSelectedIndex:self.selectedIndex andButton:sender];

    [self.delegate SSFSegmentControlDidPressed:self selectedIndex:self.selectedIndex];
}

#pragma mark - methods

- (void)updateSegmentViewForSelectedIndex:(NSInteger)index andButton:(UIButton *)button
{
    for (UIButton * button in self.items) {
        button.selected = NO;
    }
    button.selected = YES;
    
    for (UILabel * label in self.labels) {
        if (label.tag == index + 100) {
            label.textColor = [UIColor colorWithRed:44/255.0 green:186/255.0 blue:233/255.0 alpha:1.0];
        } else {
            label.textColor = [UIColor blackColor];
        }
    }
}

#pragma mark - Instance

+(SSFSegmentControl *)SSFSegmentedControlInstance
{
    //从nib中加载自定义的组件
    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"SSFSegmentControl" owner:self options:nil];
    return arr[0];
}

@end
