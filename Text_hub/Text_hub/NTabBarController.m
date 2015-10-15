//
//  NTabBarController.m
//  text_model
//
//  Created by apple on 15/6/5.
//  Copyright (c) 2015年 bitom. All rights reserved.
//

#import "NTabBarController.h"

@interface NTabBarController ()

@end

@implementation NTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setUpTabBarWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles normalImage:(NSArray *)normalImages selectedImage:(NSArray *)selectedImages
{
    if (viewControllers.count != titles.count &&  viewControllers.count != normalImages.count && viewControllers.count != selectedImages.count)
    {
        return;
    }
    
    NSMutableArray * tabBarViewControllers = [NSMutableArray array];
    
    for (int i = 0; i < viewControllers.count; i++)
    {
        UITabBarItem * tabBarItem = [[UITabBarItem alloc]initWithTitle:titles[i] image:[normalImages[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectedImages[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [(viewControllers[i]) setTabBarItem:tabBarItem];
        
        UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:viewControllers[i]];
        
        [tabBarViewControllers addObject:navigation];
    }
    
    self.viewControllers = tabBarViewControllers;
}
@end
