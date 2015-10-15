//
//  NetWorkToast.h
//  Text_hub
//
//  Created by Mr.chen on 15/10/13.
//  Copyright © 2015年 Bitom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toast+UIView.h"


@interface NetWorkToast : UIView
{
    UIView * bgView;
    UIView * contentView;
}
/**
 *  显示等待效果
 */
- (void)showWaittingIndicator;
/**
 *  关闭所有提示框
 */
- (void)closeAllToast;
/**
 *  等待结束后，显示的成功提示框(根据需求需要，如果不需要，则使用关闭所有提示框事件)
 */
- (void)finishWaittingShowSuccessToast;
/**
 *  等待结束后，显示的失败提示框(根据需求需要，如果不需要，则使用关闭所有提示框事件)
 *
 *  @param failMessage 失败内容
 */
- (void)finishWaittingShowFailToast:(NSString *)failMessage;
@end
