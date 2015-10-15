//
//  UIImage+CreateColor.m
//  B2CConsumers
//
//  Created by Mr.chen on 15/3/18.
//  Copyright (c) 2015年 pjb. All rights reserved.
//

#import "UIImage+CreateColor.h"

@implementation UIImage (CreateColor)
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
