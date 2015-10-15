//
//  AppDelegate.m
//  Text_hub
//
//  Created by Mr.chen on 14-9-6.
//  Copyright (c) 2014年 Bitom. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "NTabBarController.h"
#import "AppDelegate+OtherTransaction.h"

@implementation AppDelegate

void uncaughtExceptionHandler(NSException*exception){
    DLog("CRASH: %@", exception);
    DLog("Stack Trace: %@",[exception callStackSymbols]);
    // Internal error reporting
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //设置根视图
    NTabBarController * tabController = [[NTabBarController alloc]init];
    [tabController setUpTabBarWithViewControllers:@[[FirstViewController new],[SecondViewController new]] titles:@[@"首页",@"优惠"] normalImage:@[[UIImage imageNamed:@"pg_home_up"],[UIImage imageNamed:@"pg_favorable_up"]] selectedImage:@[[UIImage imageNamed:@"pg_home_down"],[UIImage imageNamed:@"pg_favorable_down"]]];
    tabController.tabBar.tintColor = COLOR(255.0, 35.0, 17.0, 1.0);
    self.window.rootViewController = tabController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self PushNotificationApplication:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
