//
//  ZDAddressBookTableViewCell.h
//  CRMManager
//
//  Created by peter on 14-8-28.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZDAddressBookTableViewCellDelegate;
@interface ZDAddressBookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) id <ZDAddressBookTableViewCellDelegate> delegate;

@end

@protocol ZDAddressBookTableViewCellDelegate <NSObject>

- (void)addressBookTableViewCellAddButtonPressed:(ZDAddressBookTableViewCell *)cell;

@end