//
//  ZDCustomerBusinessTableViewCellNormal.m
//  CRMManager
//
//  Created by peter on 14-8-27.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDCustomerBusinessTableViewCellNormal.h"

@implementation ZDCustomerBusinessTableViewCellNormal

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.isUnFold = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.isUnFold = !self.isUnFold;
    }
}

@end
