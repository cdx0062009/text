//
//  CycleScrollView.h
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CycleDirectionPortait,          // 垂直滚动
    CycleDirectionLandscape         // 水平滚动
}CycleDirection;
@protocol CycleScrollViewDelegate;

@interface CycleScrollView : UIView <UIScrollViewDelegate> {
    
    UIScrollView *scrollView;
    UIImageView *curImageView;
    
    int totalPage;  
    int curPage;
    CGRect scrollFrame;
    
    CycleDirection scrollDirection;     // scrollView滚动的方向
    NSArray *imagesArray;               // 存放所有需要滚动的图片 UIImage
    NSMutableArray *curImages;          // 存放当前滚动的三张图片
    
    NSTimer *timer;                            // 定时器
         // 下载图片队列
}
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *imageNum;
@property (nonatomic, assign) id<CycleScrollViewDelegate> delegate;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) NSMutableArray *imagesDownloadQueue;

- (int)validPageValue:(NSInteger)value;
- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction pictures:(NSArray *)pictureArray;
- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction downloadURL:(NSArray *)downloadURLArray;
- (NSArray *)getDisplayImagesWithCurpage:(int)page;
- (void)refreshScrollView;
- (void)setCycleDirection:(CycleDirection)direction downloadURL:(NSArray *)downloadURLArray;
/**
 *  开始显示
 */
- (void)startShow;
/**
 *  停止显示
 */
- (void)stopShow;
@end

@protocol CycleScrollViewDelegate <NSObject>
@optional
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(int)index;
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollImageView:(int)index;

@end