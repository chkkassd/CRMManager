//
//  SSFPasswordGestureView.h
//  RecoginizerPasswordDemo
//
//  Created by 施赛峰 on 14-7-22.
//  Copyright (c) 2014年 赛峰 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SSFFirstUserGesturePasswordKey  @"firstUserGesturePassword"//未设置手势密码的第一次密码
#define SSFSecondUserGesturePasswordKey  @"secondUserGesturePassword"//未设置手势密码的第二次密码
#define SSFUserGesturePasswordKey  @"UserGesturePassword"//已设置手势密码的检查密码

typedef enum {
    SSFPasswordGestureViewStateWillFirstDraw,//将要执行第一次绘制,如从来没有设置过手势密码，state传此
    SSFPasswordGestureViewStateWillAgainDraw,//将要执行第二次绘制
    SSFPasswordGestureViewStateFinishDraw,//完成两次绘制
    SSFPasswordGestureViewStateFinishWrong,//两次绘制密码不一样
    SSFPasswordGestureViewStateCheck,//检查手势密码,如已设置过，state传此
    SSFPasswordGestureViewStateCheckWrong//手势密码匹配错误
}SSFPasswordGestureViewState;

@protocol SSFPasswordGestureViewDelegate;

@interface SSFPasswordGestureView : UIView

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (strong, nonatomic) NSMutableArray *selectedButtons;
@property (nonatomic) SSFPasswordGestureViewState state;
@property (weak, nonatomic) id <SSFPasswordGestureViewDelegate> delegate;
@property (strong, nonatomic) NSString *gesturePassword;//从外部传入已设置好的手势密码,若没有，则不传

+ (SSFPasswordGestureView *)instancePasswordView;            //从xib初始化此view

@end

@protocol SSFPasswordGestureViewDelegate <NSObject>

@optional
- (void)passwordGestureViewFinishFirstTimePassword:(SSFPasswordGestureView *)passwordView;
- (void)passwordGestureViewFinishSecondTimePassword:(SSFPasswordGestureView *)passwordView andPassword:(NSString *)password;
- (void)passwordGestureViewFinishWrongPassword:(SSFPasswordGestureView *)passwordView;
- (void)passwordGestureViewFinishCheckPassword:(SSFPasswordGestureView *)passwordView;
- (void)passwordGestureViewCheckPasswordWrong:(SSFPasswordGestureView *)passwordView;

@end