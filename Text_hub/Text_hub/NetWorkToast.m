//
//  NetWorkToast.m
//  Text_hub
//
//  Created by Mr.chen on 15/10/13.
//  Copyright © 2015年 Bitom. All rights reserved.
//

#import "NetWorkToast.h"
#import "FVCustomAlertView.h"
@interface NetWorkToast()

@property (nonatomic, strong) UIActivityIndicatorView * indicator;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UIImageView * contentImageView;
@end
@implementation NetWorkToast
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)showWaittingIndicator
{
    [NSTimer scheduledTimerWithTimeInterval:0.001f target:self selector:@selector(setShow) userInfo:nil repeats:NO];
}

- (void)setShow
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    bgView = [[UIView alloc]initWithFrame:window.bounds];
    UIView * colorView = [[UIView alloc]initWithFrame:bgView.frame];
    colorView.backgroundColor = [UIColor whiteColor];
    colorView.alpha = 0.1;
    [bgView addSubview:colorView];
    [bgView sendSubviewToBack:colorView];
    
    [UIView animateWithDuration:0.15 animations:^{
        
        [window addSubview:bgView];
        
    }];
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 80)];
    contentView.center = window.center;
    contentView.backgroundColor = [UIColor blackColor];
    contentView.alpha = 0.7;
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 10;
    [bgView addSubview:contentView];
    
    self.indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(contentView.frame.origin.x + 35, contentView.frame.origin.y + 15, 30, 30)];
    [bgView addSubview:self.indicator];
    [self.indicator hidesWhenStopped];
    [self.indicator startAnimating];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y + 50, 100, 15)];
    _contentLabel.text = @"正在加载";
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_contentLabel];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
#pragma mark - close
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

#pragma mark - seccess
- (void)finishWaittingShowSuccessToast
{
    [NSTimer scheduledTimerWithTimeInterval:0.001f target:self selector:@selector(setfinishWaittingShowSuccessToast) userInfo:nil repeats:NO];
}
- (void)setfinishWaittingShowSuccessToast
{
    [self setToast:[UIImage imageNamed:@"save_finish_icon"] contentText:@"请求成功"];
}

- (void)setToast:(UIImage *)contentImage contentText:(NSString *)contentStr
{
    [UIView animateWithDuration:0.15 animations:^{
        
        [bgView removeFromSuperview];
        
    }];
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    bgView = [[UIView alloc]initWithFrame:window.bounds];
    UIView * colorView = [[UIView alloc]initWithFrame:bgView.frame];
    colorView.backgroundColor = [UIColor whiteColor];
    colorView.alpha = 0.1;
    [bgView addSubview:colorView];
    [bgView sendSubviewToBack:colorView];
    
    [UIView animateWithDuration:0.15 animations:^{
        
        [window addSubview:bgView];
        
    }];
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 80)];
    contentView.center = window.center;
    contentView.backgroundColor = [UIColor blackColor];
    contentView.alpha = 0.7;
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 10;
    [bgView addSubview:contentView];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y + 50, 100, 0)];
    _contentLabel.text = contentStr;
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 2;
    [bgView addSubview:_contentLabel];
    [_contentLabel sizeToFit];
    if (_contentLabel.frame.size.height > 18)
    {
        contentView.frame = CGRectMake(0, 0, 100, _contentLabel.frame.size.height + 65);
        contentView.center = window.center;
        self.contentLabel.frame = CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y + 50, 100, self.contentLabel.frame.size.height);
    }
    else
    {
        self.contentLabel.frame = CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y + 50, 100, 15);
    }
    self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(contentView.frame.origin.x + 35, contentView.frame.origin.y + 15, 30, 30)];
    self.contentImageView.image = contentImage;
    [bgView addSubview:self.contentImageView];
    
    //[self performSelector:@selector(close) withObject:self afterDelay:2];
}

#pragma mark - fail
- (void)finishWaittingShowFailToast:(NSString *)failMessage
{
    [NSTimer scheduledTimerWithTimeInterval:0.001f target:self selector:@selector(setfinishWaittingShowSuccessToast:) userInfo:failMessage repeats:NO];
}
- (void)setfinishWaittingShowSuccessToast:(NSTimer *)timer
{
    [self setToast:[UIImage imageNamed:@"Load_Fail_white"] contentText:(NSString *)timer.userInfo];
}
@end
