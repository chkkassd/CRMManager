//
//  ZDAddressBookTableViewCell.m
//  CRMManager
//
//  Created by peter on 14-8-28.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDAddressBookTableViewCell.h"

@implementation ZDAddressBookTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - action

- (IBAction)addButtonPressed:(id)sender
{
    [self.delegate addressBookTableViewCellAddButtonPressed:self];
}

@end
