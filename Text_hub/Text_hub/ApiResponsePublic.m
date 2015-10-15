//
//  ApiResponsePublic.m
//  XtuanMoive
//
//  Created by X团 on 14-11-17.
//  Copyright (c) 2014年 X团. All rights reserved.
//

#import "ApiResponsePublic.h"
#import <UIKit/UIKit.h>
#import "NSString+Replacing.h"

@implementation ApiResponsePublic


- (NSDictionary *)parse:(NSData *)data
{
    NSDictionary * dic = [super parse:data];
    
    if (!dic || self.status != 0)
    {
        [[[UIAlertView alloc]initWithTitle:@"请求失败" message:self.message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }
    return dic;
}

- (NSArray *)getBannerList:(NSData *)requestData
{
    [self parse:requestData];
    NSMutableArray * arrayList = [[NSMutableArray alloc]init];
    if ([self.main count] > 0)
    {
        for (NSDictionary * bannerDic in self.main)
        {
            BannerList * banner = [[BannerList alloc]init];
            banner.imageUrl = bannerDic[@"imageUrl"];
            banner.contentUrl = bannerDic[@"contentUrl"];
            [arrayList addObject:banner];
        }
    }
    return arrayList;
}

@end
