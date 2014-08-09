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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (UITabBarItem *item in self.tabBar.items) {
        switch (item.tag) {
            case 50:
                [item setFinishedSelectedImage:[UIImage imageNamed:@"ico_footer_chance_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"ico_footer_chance"]];    // 这个代码是看 登峰 的一起学。。iOS7以后好像就不能调用了。。要研究下新的API
#pragma warning 研究新的API
                break;
            case 51:
                [item setFinishedSelectedImage:[UIImage imageNamed:@"ico_footer_client_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"ico_footer_client"]];
                break;
            case 52:
                [item setFinishedSelectedImage:[UIImage imageNamed:@"ico_footer_product_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"ico_footer_product"]];
                break;
            case 53:
                [item setFinishedSelectedImage:[UIImage imageNamed:@"ico_footer_setting_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"ico_footer_setting"]];
                break;
            default:
                break;
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
