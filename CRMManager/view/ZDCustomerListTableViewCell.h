//
//  ZDCustomerListTableViewCell.h
//  CRMManager
//
//  Created by peter on 14-8-26.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDCustomerListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView * imageViewFirst;
@property (weak, nonatomic) IBOutlet UILabel * label;
@property (weak, nonatomic) IBOutlet UIView * birthView;
@property (weak, nonatomic) IBOutlet UILabel * birthLabel;
@property (weak, nonatomic) IBOutlet UIImageView * investmentImageView;

@end
