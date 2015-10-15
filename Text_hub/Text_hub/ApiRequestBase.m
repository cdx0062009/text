 //
//  ApiRequestBase.m
//  XtuanMoive
//
//  Created by ppl on 14-11-12.
//  Copyright (c) 2014年 X团. All rights reserved.
//

#import "ApiRequestBase.h"
#import "AppDelegate.h"

@implementation ApiRequestBase


- (id)init
{
    self = [super init];
    
    if (self) {
        self.resend = NO;
        self.timeout = 60;
        self.api = [[HttpApi alloc] init];
    }
    
    return self;
}

- (void)sendRequest
{
    if (self.api.connection && !self.resend) {
        return;
    }
    
    [self.api setDelegate:self.delegate];
    [self.api setTag:self.tag];
    
    if (self.api.connection && !self.resend) {
        return;
    }
    
    [self.api setDelegate:self.delegate];
    [self.api setTag:self.tag];
    
    if (self.fileDatas) {
        [self.api httpPostData:self.url withParams:self.params withData:self.fileDatas withTimeout:self.timeout];
    } else if (self.files) {
        [self.api httpPostFile:self.url withParams:self.params withFile:self.files withTimeout:self.timeout];
    } else {
        [self.api httpRequestPostJson:self.url withParams:self.params withTimeout:self.timeout];
    }
}

- (void)setIsHideIndicator:(BOOL)isHideIndicator
{
    self.api.isHideIndicator = isHideIndicator;
}
@end
