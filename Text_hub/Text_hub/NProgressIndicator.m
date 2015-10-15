//
//  NProgressIndicator.m
//  notification
//
//  Created by Mr.chen on 14-9-8.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import "NProgressIndicator.h"

@interface NProgressIndicator()

@property (nonatomic, strong) UIActivityIndicatorView * indicator;

@end


@implementation NProgressIndicator

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)show
{
    [NSTimer scheduledTimerWithTimeInterval:0.001f target:self selector:@selector(setShow) userInfo:nil repeats:NO];
}

- (void)setShow
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    bgView = [[UIView alloc]initWithFrame:window.bounds];
    UIView * colorView = [[UIView alloc]initWithFrame:bgView.frame];
    colorView.backgroundColor = [UIColor whiteColor];
    colorView.alpha = 0.5;
    [bgView addSubview:colorView];
    [bgView sendSubviewToBack:colorView];
    
    [UIView animateWithDuration:0.15 animations:^{
        
        [window addSubview:bgView];
        
    }];
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 80)];
    contentView.center = window.center;
    contentView.backgroundColor = [UIColor blackColor];
    contentView.alpha = 0.5;
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 10;
    [bgView addSubview:contentView];
    
    self.indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(contentView.frame.origin.x + 35, contentView.frame.origin.y + 15, 30, 30)];
    [bgView addSubview:self.indicator];
    [self.indicator startAnimating];
    
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y + 50, 100, 15)];
    contentLabel.text = @"正在加载";
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:contentLabel];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)close
{
    [NSTimer scheduledTimerWithTimeInterval:0.001f target:self selector:@selector(setClose) userInfo:nil repeats:NO];
}
- (void)setClose
{
    [UIView animateWithDuration:0.5 animations:^{
        
        [bgView removeFromSuperview];
        
    }];
}


@end
