//
//  ZDSelectAreaTableViewCell.m
//  CRMManager
//
//  Created by peter on 14-9-17.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDSelectAreaTableViewCell.h"

@implementation ZDSelectAreaTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
        self.contentView.backgroundColor = [UIColor brownColor];
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
