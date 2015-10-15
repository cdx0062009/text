//
//  CycleScrollView.m
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import "CycleScrollView.h"
#import "UIImage+CreateColor.h"

@implementation CycleScrollView

#pragma mark - init
- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction pictures:(NSArray *)pictureArray
{
    self = [super initWithFrame:frame];
    if(self)
    {
        imagesArray = [[NSArray alloc] initWithArray:pictureArray];
        [self initWithFrame:frame andArray:pictureArray];
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction downloadURL:(NSArray *)downloadURLArray
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _imagesDownloadQueue = [[NSMutableArray alloc]init];
        for (NSString * urlStr in downloadURLArray)
        {
            NSMutableDictionary * oneURL = [@{@"isDown": [NSNumber numberWithBool:NO],@"currentImage": [UIImage createImageWithColor:[UIColor clearColor]],@"downURL": urlStr} mutableCopy];
            [_imagesDownloadQueue addObject:oneURL];
        }
        
        [self initWithFrame:frame andArray:downloadURLArray];
    }
    
    return self;
}
- (void)initWithFrame:(CGRect)frame andArray:(NSArray *)arrayList
{
    scrollFrame = frame;
    scrollDirection = CycleDirectionLandscape;
    totalPage = (int)arrayList.count;
    curPage = 1;
    // 显示的是图片数组里的第一张图片
    curImages = nil;
    curImages = [[NSMutableArray alloc] init];
    
    
    scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    // 在水平方向滚动
    if(scrollDirection == CycleDirectionLandscape) {
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3,
                                            scrollView.frame.size.height);
    }
    // 在垂直方向滚动
    if(scrollDirection == CycleDirectionPortait) {
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                            scrollView.frame.size.height * 3);
    }
    
    [self addSubview:scrollView];
    [self refreshScrollView];
    
    /*
     ***容器，装载
     */
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-20, CGRectGetWidth(self.frame), 20)];
    containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:containerView];
    
    UIView *alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame))];
    alphaView.backgroundColor = [UIColor clearColor];
    alphaView.alpha = 0.7;
    [containerView addSubview:alphaView];
    
    //分页控制
    //CGFloat pageControlWidth = arrayList.count * 15 > CGRectGetWidth(containerView.frame) - 20 ? CGRectGetWidth(containerView.frame) - 20 : arrayList.count * 15;
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    _pageControl.numberOfPages = arrayList.count;
    _pageControl.currentPage = 0; //初始页码为0
    _pageControl.tintColor = [UIColor whiteColor];
    //[containerView addSubview:_pageControl];
    
    _imageNum = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(containerView.frame)-20, 20)];
    _imageNum.font = [UIFont boldSystemFontOfSize:15];
    _imageNum.backgroundColor = [UIColor clearColor];
    _imageNum.textColor = [UIColor whiteColor];
    _imageNum.textAlignment = NSTextAlignmentRight;
    _imageNum.text = [NSString stringWithFormat:@"1 / %d",(int)arrayList.count];
    [containerView addSubview:_imageNum];

}
#pragma mark - scroll
- (void)refreshScrollView {
    
    NSArray *subViews = [scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:curPage];
    
    //创建上一张图片，当前图片，下一张图片显示
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollFrame];
        imageView.userInteractionEnabled = YES;
        //imageView.contentMode=UIViewContentModeScaleAspectFill;
        if ([[curImages objectAtIndex:i] isKindOfClass:[UIImage class]])
        {
            imageView.image = [curImages objectAtIndex:i];
        }
        else
        {
            //已经下载完成，直接显示
            if ([[[curImages objectAtIndex:i] valueForKey:@"isDown"] boolValue])
            {
                imageView.image = [[curImages objectAtIndex:i] valueForKey:@"currentImage"];
            }
            else
            {
                //还原出在请求的图片的地址
                int pageInDownloadQueue = 0;
                if (i == 0)
                {
                    pageInDownloadQueue = [self validPageValue:curPage-1] - 1;
                }
                else if (i == 1)
                {
                    pageInDownloadQueue = curPage - 1;
                }
                else
                {
                    pageInDownloadQueue = [self validPageValue:curPage+1] - 1;
                }
                
                //更改请求状态
                [_imagesDownloadQueue replaceObjectAtIndex:pageInDownloadQueue withObject:[NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithDictionary:@{@"isDown": [NSNumber numberWithBool:YES],@"currentImage": [_imagesDownloadQueue[pageInDownloadQueue] valueForKey:@"currentImage"],@"downURL": [_imagesDownloadQueue[pageInDownloadQueue] valueForKey:@"downURL"]}]]];
                //请求图片
                if ([[curImages[i] valueForKey:@"downURL"] isKindOfClass:[NSString class]]) {
                    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[curImages[i] valueForKey:@"downURL"]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];
                    
                    __block typeof(self) weakSelf = self;
                    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (data)
                            {
                                //如果请求已经过去，则不显示
                                if (imageView.superview) {
                                    imageView.image = [UIImage imageWithData:data];
                                }
                                //保存图片
                                
                                [weakSelf.imagesDownloadQueue replaceObjectAtIndex:pageInDownloadQueue withObject:[NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithDictionary:@{@"isDown": [NSNumber numberWithBool:YES],@"currentImage":[UIImage imageWithData:data],@"downURL": [weakSelf.imagesDownloadQueue[pageInDownloadQueue] valueForKey:@"downURL"]}]]];
                            }
                            else
                            {
                                //请求失败，则从新请求
                                [weakSelf.imagesDownloadQueue replaceObjectAtIndex:pageInDownloadQueue withObject:[NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithDictionary:@{@"isDown": [NSNumber numberWithBool:NO],@"currentImage": [weakSelf.imagesDownloadQueue[pageInDownloadQueue] valueForKey:@"currentImage"],@"downURL": [weakSelf.imagesDownloadQueue[pageInDownloadQueue] valueForKey:@"downURL"]}]]];
                            }
                        });
                    }];
                }
            }
        }
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [imageView addGestureRecognizer:singleTap];
        
        // 水平滚动
        if(scrollDirection == CycleDirectionLandscape) {
            imageView.frame = CGRectOffset(imageView.frame, scrollFrame.size.width * i, 0);
        }
        // 垂直滚动
        if(scrollDirection == CycleDirectionPortait) {
            imageView.frame = CGRectOffset(imageView.frame, 0, scrollFrame.size.height * i);
        }
        
        
        [scrollView addSubview:imageView];
    }
    if (scrollDirection == CycleDirectionLandscape) {
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0)];
    }
    if (scrollDirection == CycleDirectionPortait) {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height)];
    }
}

- (NSArray *)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:curPage-1];
    int last = [self validPageValue:curPage+1];
    
    if([curImages count] != 0)
    {
        [curImages removeAllObjects];
    }
    
    if (_imagesDownloadQueue.count > 0)
    {
        [curImages addObject:_imagesDownloadQueue[pre - 1]];
        [curImages addObject:_imagesDownloadQueue[curPage - 1]];
        [curImages addObject:_imagesDownloadQueue[last - 1]];
    }
    else
    {
        [curImages addObject:[imagesArray objectAtIndex:pre-1]];
        [curImages addObject:[imagesArray objectAtIndex:curPage-1]];
        [curImages addObject:[imagesArray objectAtIndex:last-1]];
    }
    
    return curImages;
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == 0) value = totalPage;                   // value＝1为第一张，value = 0为前面一张
    if(value == totalPage + 1) value = 1;
    
    return (int)value;
}

#pragma mark - show
- (void)startShow
{
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)stopShow
{
    [timer invalidate];
    timer = nil;
}

#pragma mark - timer

-(void)timerAction:(NSTimer *)timer
{
    [scrollView setContentOffset:CGPointMake(2*scrollFrame.size.width, scrollView.contentOffset.y) animated:YES];
}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    int x = aScrollView.contentOffset.x;
    int y = aScrollView.contentOffset.y;
    
    // 水平滚动
    if(scrollDirection == CycleDirectionLandscape) {
        // 往下翻一张
        if(x >= (2*scrollFrame.size.width)) { 
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(x <= 0) {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    // 垂直滚动
    if(scrollDirection == CycleDirectionPortait) {
        // 往下翻一张
        if(y >= 2 * (scrollFrame.size.height)) { 
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(y <= 0) {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    _pageControl.currentPage = curPage - 1;
    _imageNum.text = [NSString stringWithFormat:@"%d / %d",curPage,totalPage];
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollImageView:)]) {
        [self.delegate cycleScrollViewDelegate:self didScrollImageView:curPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    if (scrollDirection == CycleDirectionLandscape)
    {
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0) animated:YES];
    }
    if (scrollDirection == CycleDirectionPortait) {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height) animated:YES];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewDelegate:didSelectImageView:)]) {
        [self.delegate cycleScrollViewDelegate:self didSelectImageView:curPage];
    }
}

- (void)dealloc
{
    self.delegate = nil;
    _imagesDownloadQueue = nil;
    imagesArray = nil;
    curImages = nil;
}
@end
