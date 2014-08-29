//
//  ZDFilterdAddressBookTableViewCell.m
//  CRMManager
//
//  Created by peter on 14-8-28.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDFilterdAddressBookTableViewCell.h"

@implementation ZDFilterdAddressBookTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addButtonPressed:(id)sender
{
    [self.delegate filterdAddressBookTableViewCellAddButtonPreseed:self];
}

@end
