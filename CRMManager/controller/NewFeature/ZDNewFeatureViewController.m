//
//  ZDNewFeatureViewController.m
//  CRMManager
//
//  Created by apple on 14-9-25.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDNewFeatureViewController.h"

#define kCount 4

@interface ZDNewFeatureViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* scroll;
@property (nonatomic, strong) UIPageControl* page;

@end

@implementation ZDNewFeatureViewController


#pragma mark 自定义view

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.添加UIScrollView
    [self addScrollView];
    
    // 2.添加图片
    [self addScrollImages];
    
    // 3.添加UIPageControl
    [self addPageControl];
}

#pragma mark - UI界面初始化
#pragma mark 添加滚动视图
- (void)addScrollView
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = self.view.bounds;
    scroll.showsHorizontalScrollIndicator = NO; // 隐藏水平滚动条
    CGSize size = scroll.frame.size;
    scroll.contentSize = CGSizeMake(size.width * kCount, 0); // 内容尺寸
    scroll.pagingEnabled = YES; // 分页
    scroll.delegate = self;
    [self.view addSubview:scroll];
    _scroll = scroll;
}

#pragma mark 添加滚动显示的图片
- (void)addScrollImages
{
    CGSize size = _scroll.frame.size;
    
    for (int i = 0; i<kCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        // 1.显示图片
        NSString *name = [NSString stringWithFormat:@"guiding%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        // 2.设置frame
        imageView.frame = CGRectMake(i * size.width, 0, size.width, size.height);
        [_scroll addSubview:imageView];
        
        if (i == kCount - 1) { // 最后一页，添加2个按钮
            // 3.立即体验（开始）
            UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *startNormal = [UIImage imageNamed:@"new_feature_finish_button.png"];
            [start setBackgroundImage:startNormal forState:UIControlStateNormal];
            [start setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted.png"] forState:UIControlStateHighlighted];
            start.center = CGPointMake(size.width * 0.5, size.height * 0.8);
            //            start.bounds = CGRectMake(0, 0, startNormal.size.width, startNormal.size.height);
            start.bounds = (CGRect){CGPointZero, startNormal.size};
            [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:start];
            imageView.userInteractionEnabled = YES;
        }
    }
}

- (void)start
{
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"login"] animated:YES completion:nil];
}

#pragma mark 添加分页指示器
- (void)addPageControl
{
    CGSize size = self.view.frame.size;
    UIPageControl *page = [[UIPageControl alloc] init];
    page.center = CGPointMake(size.width * 0.5, size.height * 0.95);
    page.numberOfPages = kCount;
    page.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_checked_point.png"]];
    page.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_point.png"]];
    page.bounds = CGRectMake(0, 0, 150, 0);
    [self.view addSubview:page];
    _page = page;
}


#pragma mark - 滚动代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.page.currentPage = self.scroll.contentOffset.x / self.scroll.frame.size.width;
}

@end