//
//  NTabBarController.h
//  text_model
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 bitom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTabBarController : UITabBarController
-(void)setUpTabBarWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles normalImage:(NSArray *)normalImages selectedImage:(NSArray *)selectedImages;
@end
