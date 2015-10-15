//
//  NProgressIndicator.h
//  notification
//
//  Created by Mr.chen on 14-9-8.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NProgressIndicator : UIView
{
    UIView * bgView;
    UIView * contentView;
}
- (void)show;
- (void)close;
@end

