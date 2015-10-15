//
//  AppDelegate+OtherTransaction.m
//  Text_hub
//
//  Created by Mr.chen on 15/10/13.
//  Copyright © 2015年 Bitom. All rights reserved.
//

#import "AppDelegate+OtherTransaction.h"
#import "UserDefaultsMessage.h"

@implementation AppDelegate (OtherTransaction)
- (void)PushNotificationApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /**
     * 注册推送通知
     */
    if (IOS_VERSION >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    }
    
    //清除右上角图标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if (application.applicationState == UIApplicationStateActive)
    {
        
    }else
    {
        if (launchOptions) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NPushNotification object:self userInfo:nil];
        }
    }
}
#pragma mark - 注册推送通知之后
//在此接收设备令牌
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    UserDefaultsMessage * userMessage = [[UserDefaultsMessage alloc]init];
    NSString * deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    //如果偏好设置中的已存储设备令牌和新获取的令牌不同则存储新令牌并且发送给服务器端
    if (![userMessage.deviceToken isEqualToString:deviceTokenString]) {
        userMessage.deviceToken = deviceTokenString;
    }
}
#pragma mark - 获取device token失败后
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Regist fail%@",error);
}
#pragma mark - 处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
     NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
}
@end
