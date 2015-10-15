//
//  ApiRequestRoot.m
//  XtuanMoive
//
//  Created by X团 on 14-11-13.
//  Copyright (c) 2014年 X团. All rights reserved.
//

#import "ApiRequestRoot.h"

@interface ApiRequestRoot()
//整合加密
@property (nonatomic,strong) NSString * userToken;
@property (nonatomic,strong) NSString * uesrMenberID;
@end

@implementation ApiRequestRoot

- (void)postBannerList:(id<HttpApiDelegate>)delegate withTag:(NSObject *)tag
{
    self.tag = tag;
    self.delegate = delegate;
    self.url = [NSString stringWithFormat:@"https://www.baidu.com"];
    [self sendRequest];
}

@end
