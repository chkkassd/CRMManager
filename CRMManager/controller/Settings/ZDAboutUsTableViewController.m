//
//  ZDAboutUsTableViewController.m
//  CRMManager
//
//  Created by apple on 14-8-20.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDAboutUsTableViewController.h"
#import "UIView+CCPlus.h"
#import "AllCustomerCategoryHeaders.h"

#define VERSION_URL @"http://api.ezendai.com:8888/ios/manager_version.txt"
#define INSTALL_URL @"itms-services://?action=download-manifest&url=https://api.ezendai.com:8899/ios/manager.plist"

@interface ZDAboutUsTableViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *seperatorLines;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation ZDAboutUsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.versionLabel.text = [NSString stringWithFormat:@"V %@", [self currentAppVersion]];
    
    [UIView configureSeparatorLinesFromOutletCollections:self.seperatorLines
                                         withBorderWidth:0.25
                                         withBorderColor:[UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:0.5]];
}

- (NSString *)currentAppVersion
{
    NSDictionary* info = [[NSBundle mainBundle] infoDictionary];
    return info[@"CFBundleShortVersionString"];
}

- (void)haveNewVersion
{
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:INSTALL_URL]];
}

- (void)noHaveNewVersion
{
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"已是最新版本"
                               delegate:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil] show];
}

- (void)compareCurrentAppVersion:(NSString *)currentAppVersion appStoreAppVersion:(NSString *)appStoreAppVersion
{
    int currentAppVersion1 = 0;
    int currentAppVersion2 = 0;
    int currentAppVersion3 = 0;
    int appStoreAppVersion1 = 0;
    int appStoreAppVersion2 = 0;
    int appStoreAppVersion3 = 0;
    
    NSArray *components = [currentAppVersion componentsSeparatedByString:@"."];
    if ([components count] > 0) currentAppVersion1 = [components[0] intValue];
    if ([components count] > 1) currentAppVersion2 = [components[1] intValue];
    if ([components count] > 2) currentAppVersion3 = [components[2] intValue];
    
    components = [appStoreAppVersion componentsSeparatedByString:@"."];
    if ([components count] > 0) appStoreAppVersion1 = [components[0] intValue];
    if ([components count] > 1) appStoreAppVersion2 = [components[1] intValue];
    if ([components count] > 2) appStoreAppVersion3 = [components[2] intValue];
    
    if (appStoreAppVersion1 > currentAppVersion1) {
        [self haveNewVersion];
    } else if (appStoreAppVersion1 == currentAppVersion1) {
        if (appStoreAppVersion2 > currentAppVersion2) {
            [self haveNewVersion];
        } else if (appStoreAppVersion2 == currentAppVersion2) {
            if (appStoreAppVersion3 > currentAppVersion3) {
                [self haveNewVersion];
            } else {
                [self noHaveNewVersion];
            }
        } else {
            [self noHaveNewVersion];
        }
    } else {
        [self noHaveNewVersion];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 3) {
        [self checkUpdatePressed];
    }
}

#pragma mark - Action

- (void)checkUpdatePressed
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:VERSION_URL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSString *appStoreAppVersion = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *currentAppVersion = [self currentAppVersion];
            
            [self compareCurrentAppVersion:currentAppVersion appStoreAppVersion:appStoreAppVersion];
        });
    });
}

@end
