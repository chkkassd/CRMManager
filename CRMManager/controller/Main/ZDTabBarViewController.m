//
//  ZDTabBarViewController.m
//  CRMManager
//
//  Created by peter on 14-8-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDTabBarViewController.h"

// 这个类是总的Main控制器类

@interface ZDTabBarViewController ()

@end

@implementation ZDTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for (int i = 0; i < self.tabBar.items.count; i++) {
        switch (i) {
            case 0:{
                UITabBarItem * barItem = self.tabBar.items[i];
                barItem.selectedImage = [UIImage imageNamed:@"main_ico_footer_chance_pressed"];
                 break;
            }
            case 1:{
                UITabBarItem * barItem = self.tabBar.items[i];
                barItem.selectedImage = [UIImage imageNamed:@"main_ico_footer_client_pressed"];
                break;
            }
            case 2:{
                UITabBarItem * barItem = self.tabBar.items[i];
                barItem.selectedImage = [UIImage imageNamed:@"main_ico_footer_product_pressed"];
                break;
            }
            case 3:{
                UITabBarItem * barItem = self.tabBar.items[i];
                barItem.selectedImage = [UIImage imageNamed:@"maini_ico_footer_setting_pressed"];
                break;
            }
            default:
                break;
        }
    }
}

@end
