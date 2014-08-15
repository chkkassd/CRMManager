//
//  SSFPasswordGestureView.m
//  RecoginizerPasswordDemo
//
//  Created by 施赛峰 on 14-7-22.
//  Copyright (c) 2014年 赛峰 施. All rights reserved.
//

#import "SSFPasswordGestureView.h"
#import "SSFPathLineLayer.h"
#import <math.h>

#define SSFPointRaious 32

@interface SSFPasswordGestureView()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *pointButtons;
@property (strong, nonatomic) NSMutableArray *unselectedButtons;
@property (strong, nonatomic) SSFPathLineLayer *pathLayer;

@end

@implementation SSFPasswordGestureView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.pathLayer = [SSFPathLineLayer layer];
        self.pathLayer.passwordGestureView = self;
        self.pathLayer.frame = self.bounds;
        [self.layer addSublayer:self.pathLayer];
    }
    return self;
}

#pragma mark - panGesture Action

- (IBAction)firstPointButtonPressed:(UIButton *)sender
{
    UIButton *startPointButton = (UIButton *)[self viewWithTag:sender.tag];
//    startPointButton.backgroundColor = [UIColor redColor];
    startPointButton.selected = YES;
    self.startPoint = startPointButton.center;
    self.endPoint = self.startPoint;
}

- (IBAction)panGestureHandle:(UIPanGestureRecognizer *)sender
{
    CGPoint newPoint = [sender translationInView:self];
    self.endPoint = CGPointMake(self.endPoint.x + newPoint.x, self.endPoint.y + newPoint.y);
    [self reachButtonWithPoint:self.endPoint];
    [self.pathLayer setNeedsDisplay];
    [sender setTranslation:CGPointMake(0, 0) inView:self];

    if (sender.state == UIGestureRecognizerStateEnded) {
        //绘制完成先保存密码
        NSString *string = [[NSString alloc] init];
        if (self.state == SSFPasswordGestureViewStateWillFirstDraw) {
            for (int i = 0; i < self.selectedButtons.count; i++) {
                UIButton *button = self.selectedButtons[i];
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%d",(int)button.tag]];
            }
            [[NSUserDefaults standardUserDefaults] setObject:string forKey:SSFFirstUserGesturePasswordKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else if (self.state == SSFPasswordGestureViewStateWillAgainDraw || self.state == SSFPasswordGestureViewStateFinishWrong) {
            for (int i = 0; i < self.selectedButtons.count; i++) {
                UIButton *button = self.selectedButtons[i];
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%d",(int)button.tag]];
            }
            [[NSUserDefaults standardUserDefaults] setObject:string forKey:SSFSecondUserGesturePasswordKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else if (self.state == SSFPasswordGestureViewStateCheck || self.state == SSFPasswordGestureViewStateCheckWrong) {
            for (int i = 0; i < self.selectedButtons.count; i++) {
                UIButton *button = self.selectedButtons[i];
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%d",(int)button.tag]];
            }
            [[NSUserDefaults standardUserDefaults] setObject:string forKey:SSFUserGesturePasswordKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
        //所有button变回最初状态
        for (UIButton *button in self.pointButtons) {
//            button.backgroundColor = [UIColor blackColor];
            button.selected = NO;
        }
        
        //属性初始化
        self.selectedButtons = nil;
        self.unselectedButtons = nil;
        self.startPoint = CGPointMake(0, 0);
        self.endPoint = CGPointMake(0, 0);
        [self.pathLayer setNeedsDisplay];
        
        //状态切换
        if (self.state == SSFPasswordGestureViewStateWillFirstDraw) {
            self.state = SSFPasswordGestureViewStateWillAgainDraw;
        } else if (self.state == SSFPasswordGestureViewStateWillAgainDraw || self.state == SSFPasswordGestureViewStateFinishWrong) {
            if ([self checkFirstAndSecondPassword]) {
                self.state = SSFPasswordGestureViewStateFinishDraw;
            } else {
                self.state = SSFPasswordGestureViewStateFinishWrong;
            }
        } else if (self.state == SSFPasswordGestureViewStateCheck || self.state == SSFPasswordGestureViewStateCheckWrong) {
            if ([self checkGesturePassword]) {
                self.state = SSFPasswordGestureViewStateCheck;
            } else {
                self.state = SSFPasswordGestureViewStateCheckWrong;
            }
        }
        
        //根据状态来执行不同的操作
        switch (self.state) {
            case SSFPasswordGestureViewStateWillAgainDraw:
                //完成第一次手绘密码，提醒继续第二次手绘
                if ([self.delegate respondsToSelector:@selector(passwordGestureViewFinishFirstTimePassword:)]) {
                    [self.delegate passwordGestureViewFinishFirstTimePassword:self];
                }
                break;
            case SSFPasswordGestureViewStateFinishDraw:
            {
                //完成第二次手绘密码,并与第一次密码相同
                NSString * gpd = [[NSUserDefaults standardUserDefaults] objectForKey:SSFSecondUserGesturePasswordKey];
                if (gpd.length) {
                    if ([self.delegate respondsToSelector:@selector(passwordGestureViewFinishSecondTimePassword:andPassword:)]) {
                        [self.delegate passwordGestureViewFinishSecondTimePassword:self andPassword:gpd];
                    }
                }
                break;
            }
            case SSFPasswordGestureViewStateFinishWrong:
                //第一次与第二次密码不一样
                if ([self.delegate respondsToSelector:@selector(passwordGestureViewFinishWrongPassword:)]) {
                    [self.delegate passwordGestureViewFinishWrongPassword:self];
                }
                break;
            case SSFPasswordGestureViewStateCheck:
            {
                //check手势密码成功
                if ([self.delegate respondsToSelector:@selector(passwordGestureViewFinishCheckPassword:)]) {
                    [self.delegate passwordGestureViewFinishCheckPassword:self];
                }
                break;
            }
            case SSFPasswordGestureViewStateCheckWrong:
                //check手势密码失败
                if ([self.delegate respondsToSelector:@selector(passwordGestureViewCheckPasswordWrong:)]) {
                    [self.delegate passwordGestureViewCheckPasswordWrong:self];
                }
                break;
            default:
                break;
        }
    }
}

- (IBAction)firstPointButtonTouchUpInside:(UIButton *)sender
{
    if (!self.selectedButtons.count) {
        sender.backgroundColor = [UIColor blackColor];
    }
}

#pragma mark - methods

- (void)reachButtonWithPoint:(CGPoint)point
{
    for (UIButton * button in self.unselectedButtons) {
        CGPoint buttonPoint = button.center;
        CGFloat distance = sqrtf(powf(fabsf(point.x - buttonPoint.x) , 2) + powf(fabsf(point.y - buttonPoint.y) , 2));
        if (distance <= SSFPointRaious) {
            button.selected = YES;
//            button.backgroundColor = [UIColor redColor];
            [self.unselectedButtons removeObject:button];
            [self.selectedButtons addObject:button];//完成一次绘制后要清空
            break;
        }
    }
}

- (BOOL)checkFirstAndSecondPassword
{
    NSString *password1 = [[NSUserDefaults standardUserDefaults] objectForKey:SSFFirstUserGesturePasswordKey];
    NSString *password2 = [[NSUserDefaults standardUserDefaults] objectForKey:SSFSecondUserGesturePasswordKey];
    if ([password1 isEqualToString:password2]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码设置成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
        return YES;
    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码设置有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
        return NO;
    }
}

- (BOOL)checkGesturePassword
{
    if (self.gesturePassword) {
        NSString *checkPassword = [[NSUserDefaults standardUserDefaults] objectForKey:SSFUserGesturePasswordKey];
        if ([self.gesturePassword isEqualToString:checkPassword]) {
            return YES;
        } else return NO;
    } else return NO;
}

#pragma mark - properties

- (void)setPointButtons:(NSArray *)pointButtons
{
    _pointButtons = pointButtons;
    for (UIButton *button in _pointButtons) {
        button.layer.cornerRadius = 30.0;
    }
    self.unselectedButtons = [_pointButtons mutableCopy];
}

- (NSMutableArray *)selectedButtons
{
    if (!_selectedButtons) {
        _selectedButtons = [[NSMutableArray alloc] init];
    }
    return _selectedButtons;
}

- (NSMutableArray *)unselectedButtons
{
    if (!_unselectedButtons) {
        _unselectedButtons = [self.pointButtons mutableCopy];
    }
    return _unselectedButtons;
}

#pragma mark - instance method

+ (SSFPasswordGestureView *)instancePasswordView
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"SSFPasswordGestureView" owner:self options:nil];
    return arr[0];
}

@end
