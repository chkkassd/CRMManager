//
//  ZDFilterdAddressBookTableViewCell.h
//  CRMManager
//
//  Created by peter on 14-8-28.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZDFilterdAddressBookTableViewCellDelegate;
@interface ZDFilterdAddressBookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) id <ZDFilterdAddressBookTableViewCellDelegate> delegate;

@end

@protocol ZDFilterdAddressBookTableViewCellDelegate <NSObject>

- (void)filterdAddressBookTableViewCellAddButtonPreseed:(ZDFilterdAddressBookTableViewCell *)cell;

@end